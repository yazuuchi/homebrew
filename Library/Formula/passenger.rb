class Passenger < Formula
  desc "Server for Ruby, Python, and Node.js apps via Apache/NGINX"
  homepage "https://www.phusionpassenger.com/"
  url "https://s3.amazonaws.com/phusion-passenger/releases/passenger-5.0.24.tar.gz"
  sha256 "06b9cdd18c1ef283628b753815ae1c6eaf764f212fd8d439d7035c9257288f79"
  head "https://github.com/phusion/passenger.git"

  bottle do
    cellar :any
    sha256 "3c4cdcb86c015b3e72efe552588622ee5ef359a209b0c2d0bc88bdfaed906e26" => :el_capitan
    sha256 "d0e4b37b06ff3f5298aba4624edded661ac48802eee9a69684c45cd9f29558e5" => :yosemite
    sha256 "81045cc5954dd3e20848ccafaad989c43702ea923724128df5ba0715cd6a0446" => :mavericks
  end

  depends_on "pcre"
  depends_on "openssl"
  depends_on :macos => :lion

  option "without-apache2-module", "Disable Apache2 module"

  def install
    rake "apache2" if build.with? "apache2-module"
    rake "nginx"

    system("/usr/bin/ruby ./bin/passenger-config compile-nginx-engine")

    (libexec/"download_cache").mkpath

    # Fixes https://github.com/phusion/passenger/issues/1288
    rm_rf "buildout/libev"
    rm_rf "buildout/libuv"
    rm_rf "buildout/cache"

    necessary_files = Dir[".editorconfig", "configure", "Rakefile", "README.md", "CONTRIBUTORS",
      "CONTRIBUTING.md", "LICENSE", "CHANGELOG", "INSTALL.md",
      "passenger.gemspec", "build", "bin", "doc", "man", "dev", "src",
      "resources", "buildout"]
    libexec.mkpath
    cp_r necessary_files, libexec, :preserve => true

    # Allow Homebrew to create symlinks for the Phusion Passenger commands.
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Ensure that the Phusion Passenger commands can always find their library
    # files.

    locations_ini = `/usr/bin/ruby ./bin/passenger-config --make-locations-ini --for-native-packaging-method=homebrew`
    locations_ini.gsub!(/=#{Regexp.escape Dir.pwd}/, "=#{libexec}")
    (libexec/"src/ruby_supportlib/phusion_passenger/locations.ini").write(locations_ini)

    ruby_libdir = `/usr/bin/ruby ./bin/passenger-config about ruby-libdir`.strip
    ruby_libdir.gsub!(/^#{Regexp.escape Dir.pwd}/, libexec)
    system "/usr/bin/ruby", "./dev/install_scripts_bootstrap_code.rb",
      "--ruby", ruby_libdir, *Dir[libexec/"bin/*"]

    nginx_addon_dir = `/usr/bin/ruby ./bin/passenger-config about nginx-addon-dir`.strip
    nginx_addon_dir.gsub!(/^#{Regexp.escape Dir.pwd}/, libexec)
    system "/usr/bin/ruby", "./dev/install_scripts_bootstrap_code.rb",
      "--nginx-module-config", libexec/"bin", "#{nginx_addon_dir}/config"

    mv libexec/"man", share
  end

  def caveats
    s = <<-EOS.undent
      To activate Phusion Passenger for Nginx, run:
        brew install nginx --with-passenger

      EOS

    s += <<-EOS.undent if build.with? "apache2-module"
      To activate Phusion Passenger for Apache, create /etc/apache2/other/passenger.conf:
        LoadModule passenger_module #{opt_libexec}/buildout/apache2/mod_passenger.so
        PassengerRoot #{opt_libexec}/src/ruby_supportlib/phusion_passenger/locations.ini
        PassengerDefaultRuby /usr/bin/ruby

      EOS
    s
  end

  test do
    ruby_libdir = `#{HOMEBREW_PREFIX}/bin/passenger-config --ruby-libdir`.strip
    assert_equal "#{libexec}/src/ruby_supportlib", ruby_libdir
  end
end
