require 'formula'

class Rabbitmq < Formula
  homepage 'http://www.rabbitmq.com'
  url 'https://www.rabbitmq.com/releases/rabbitmq-server/v3.4.1/rabbitmq-server-mac-standalone-3.4.1.tar.gz'
  sha1 'f1cf93cbfe7d5b12d426819c890f9b688868180a'

  bottle do
    sha1 "f60e1c485e5c415a1614631ca8ff9cd2024bcc33" => :yosemite
    sha1 "6eb8e5c6108741dff767a108353a85a74f7aa833" => :mavericks
    sha1 "c3fd2b3cc376bb4d7f63de5e4d96a1eebd15f6af" => :mountain_lion
  end

  # Upstream fix for rabbitmqctl:
  # http://hg.rabbitmq.com/rabbitmq-server/raw-rev/3f7c77cdafd8
  patch :DATA

  depends_on 'simplejson' => :python if MacOS.version <= :leopard

  def install
    # Install the base files
    prefix.install Dir['*']

    # Setup the lib files
    (var+'lib/rabbitmq').mkpath
    (var+'log/rabbitmq').mkpath

    # Correct SYS_PREFIX for things like rabbitmq-plugins
    inreplace sbin/'rabbitmq-defaults' do |s|
      s.gsub! 'SYS_PREFIX=${RABBITMQ_HOME}', "SYS_PREFIX=#{HOMEBREW_PREFIX}"
      s.gsub! 'CLEAN_BOOT_FILE="${SYS_PREFIX}', "CLEAN_BOOT_FILE=\"#{prefix}"
      s.gsub! 'SASL_BOOT_FILE="${SYS_PREFIX}', "SASL_BOOT_FILE=\"#{prefix}"
    end

    # Set RABBITMQ_HOME in rabbitmq-env
    inreplace (sbin + 'rabbitmq-env'), 'RABBITMQ_HOME="${SCRIPT_DIR}/.."', "RABBITMQ_HOME=#{prefix}"

    # Create the rabbitmq-env.conf file
    rabbitmq_env_conf = etc+'rabbitmq/rabbitmq-env.conf'
    rabbitmq_env_conf.write rabbitmq_env unless rabbitmq_env_conf.exist?

    # Enable plugins - management web UI and visualiser; STOMP, MQTT, AMQP 1.0 protocols
    enabled_plugins_path = etc+'rabbitmq/enabled_plugins'
    enabled_plugins_path.write '[rabbitmq_management,rabbitmq_management_visualiser,rabbitmq_stomp,rabbitmq_amqp1_0,rabbitmq_mqtt].' unless enabled_plugins_path.exist?

    # Extract rabbitmqadmin and install to sbin
    # use it to generate, then install the bash completion file
    system "/usr/bin/unzip", "-qq", "-j",
           "#{prefix}/plugins/rabbitmq_management-#{version}.ez",
           "rabbitmq_management-#{version}/priv/www/cli/rabbitmqadmin"

    sbin.install 'rabbitmqadmin'
    (sbin/'rabbitmqadmin').chmod 0755
    (bash_completion/'rabbitmqadmin.bash').write `#{sbin}/rabbitmqadmin --bash-completion`
  end

  def caveats; <<-EOS.undent
    Management Plugin enabled by default at http://localhost:15672
    EOS
  end

  def rabbitmq_env; <<-EOS.undent
    CONFIG_FILE=#{etc}/rabbitmq/rabbitmq
    NODE_IP_ADDRESS=127.0.0.1
    NODENAME=rabbit@localhost
    EOS
  end

  plist_options :manual => 'rabbitmq-server'

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>Program</key>
        <string>#{opt_sbin}/rabbitmq-server</string>
        <key>RunAtLoad</key>
        <true/>
        <key>EnvironmentVariables</key>
        <dict>
          <!-- need erl in the path -->
          <key>PATH</key>
          <string>/usr/local/sbin:/usr/bin:/bin:/usr/local/bin</string>
          <!-- specify the path to the rabbitmq-env.conf file -->
          <key>CONF_ENV_FILE</key>
          <string>#{etc}/rabbitmq/rabbitmq-env.conf</string>
        </dict>
      </dict>
    </plist>
    EOS
  end
end


__END__
--- a/sbin/rabbitmqctl
+++ b/sbin/rabbitmqctl
@@ -21,7 +21,8 @@

 # rabbitmqctl starts distribution itself, so we need to make sure epmd
 # is running.
-${ERL_DIR}erl ${RABBITMQ_NAME_TYPE} rabbitmqctl-prelaunch-$$ -noinput -eval 'erlang:halt().'
+${ERL_DIR}erl ${RABBITMQ_NAME_TYPE} rabbitmqctl-prelaunch-$$ -noinput \
+-eval 'erlang:halt().' -boot "${CLEAN_BOOT_FILE}"

 # We specify Mnesia dir and sasl error logger since some actions
 # (e.g. forget_cluster_node --offline) require us to impersonate the
