require 'formula'

class HpnSsh < Formula
  homepage 'http://www.openssh.com/'
  url 'http://ftp5.eu.openbsd.org/ftp/pub/OpenBSD/OpenSSH/portable/openssh-6.7p1.tar.gz'
  version '6.7p1'
  sha1 '14e5fbed710ade334d65925e080d1aaeb9c85bf6'

  option 'with-brewed-openssl', 'Build with Homebrew OpenSSL instead of the system version'
  option 'without-keychain-support', 'Build without keychain and launch daemon support'

  depends_on 'autoconf' => :build if build.with? 'keychain-support'
  depends_on 'openssl' if build.with? 'brewed-openssl'
  depends_on 'ldns' => :optional
  depends_on 'pkg-config' => :build if build.with? "ldns"

  conflicts_with 'openssh'

  patch do
    url "http://www.honeyplanet.jp/openssh_67p1_hpn14v5.diff"
    sha1 "fb8b57c5b20a5a67a617396d132fb3d7fbe1d216"
  end

  patch do
    url "http://www.honeyplanet.jp/openssh_67p1_post_hpn14v5_backout_CTR_threading.diff"
    sha1 "2c5b8d2b47155bfc4ab1b5609bb0542d145af340"
  end

  if build.with? 'keychain-support'
    patch do
      url "http://www.honeyplanet.jp/openssh_67p1_post_hpn14v5_keychain.diff"
      sha1 "0253eb966709559c0daead3457da6344a92c3300"
    end
  end

  def install
    if build.with? "keychain-support"
      ENV.append "CPPFLAGS", "-D__APPLE_LAUNCHD__ -D__APPLE_KEYCHAIN__"
      ENV.append "LDFLAGS", "-framework CoreFoundation -framework SecurityFoundation -framework Security"
    end

    args = %W[
      --with-libedit
      --with-kerberos5
      --prefix=#{prefix}
      --sysconfdir=#{etc}/ssh
    ]

    args << "--with-ssl-dir=#{Formula.factory('openssl').opt_prefix}" if build.with? 'brewed-openssl'
    args << "--with-ldns" if build.with? "ldns"
    args << "--without-openssl-header-check"

    system "/usr/local/bin/autoreconf -i" if build.with? 'keychain-support'
    system "./configure", *args
    system "make"
    system "make install"
  end

  def caveats
    if build.with? 'keychain-support' then <<-EOS.undent
      For complete functionality, please modify:
        /System/Library/LaunchAgents/org.openbsd.ssh-agent.plist
      and change ProgramArugments from
        /usr/bin/ssh-agent
      to
        /usr/local/bin/ssh-agent
      After that, you can start storing private key passwords in
      your OS X Keychain.
      EOS
    end
  end

end
