require 'formula'

class HpnSsh < Formula
  homepage 'http://www.openssh.com/'
  url 'http://ftp5.eu.openbsd.org/ftp/pub/OpenBSD/OpenSSH/portable/openssh-6.6p1.tar.gz'
  version '6.6p1'
  sha1 'b850fd1af704942d9b3c2eff7ef6b3a59b6a6b6e'

  option 'with-brewed-openssl', 'Build with Homebrew OpenSSL instead of the system version'
  option 'without-keychain-support', 'Build without keychain and launch daemon support'

  depends_on 'autoconf' => :build if build.with? 'keychain-support'
  depends_on 'openssl' if build.with? 'brewed-openssl'
  depends_on 'ldns' => :optional
  depends_on 'pkg-config' => :build if build.with? "ldns"

  conflicts_with 'openssh'

  patch do
    url "http://www.honeyplanet.jp/openssh_66_hpn.diff"
    sha1 "4a915f0464b2d44f3e581c95eb0260b54f8c235e"
  end

  if build.with? 'keychain-support'
    patch do
      url "http://www.honeyplanet.jp/openssh_66_post_hpn_keychain.diff"
      sha1 "45e2321c5c672f321c8953fa3bb3324a94312046"
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
