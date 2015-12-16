class Knot < Formula
  desc "High-performance authoritative-only DNS server"
  homepage "https://www.knot-dns.cz/"
  url "https://secure.nic.cz/files/knot-dns/knot-1.6.6.tar.xz"
  sha256 "6ccae42b0878201e2113a048317bf518acad70fe436b04e24da32703d27edf03"

  head do
    url "https://gitlab.labs.nic.cz/labs/knot.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
  end

  bottle do
    cellar :any
    sha256 "90e45148b081f6c98c9d181e3b89f08ce0db4a47199c4d194b67d758420442a2" => :el_capitan
    sha256 "40afc8d6991964587e1637847ad13cd4825d28064144fc1b5a3f7228705ea7c1" => :yosemite
    sha256 "b100ac007518f53f4829b0cb45c67f287a0fc99ee1846b6526959635291b1ce8" => :mavericks
  end

  depends_on "gnutls"
  depends_on "jansson"
  depends_on "libidn"
  depends_on "nettle"
  depends_on "openssl"
  depends_on "userspace-rcu"

  def install
    system "autoreconf", "-i", "-f" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-configdir=#{etc}",
                          "--with-storage=#{var}/knot",
                          "--with-rundir=#{var}/knot",
                          "--prefix=#{prefix}"

    inreplace "samples/Makefile", "install-data-local:", "disable-install-data-local:"

    system "make"
    system "make", "install"

    (buildpath/"knot.conf").write(knot_conf)
    etc.install "knot.conf"

    (var/"knot").mkpath
  end

  def knot_conf; <<-EOS.undent
    system {
      identity on;
      version on;
      rundir "#{var}/knot";
    }
    interfaces {
      all_ipv4 {
        address 0.0.0.0;
        port 53;
      }
      all_ipv6 {
        address [::];
        port 53;
      }
    }
    control {
      listen-on "knot.sock";
    }
    zones {
      storage "#{var}/knot";
    #  example.com {
    #    file "#{var}/knot/example.com.zone";
    #  }
    }
    log {
      syslog {
        any error;
        zone warning, notice;
        server info;
      }
      stderr {
        any error, warning;
      }
    }
    EOS
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>EnableTransactions</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>RunAtLoad</key>
      <true/>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_sbin}/knotd</string>
        <string>-c</string>
        <string>#{etc}/knot.conf</string>
      </array>
      <key>ServiceIPC</key>
      <false/>
    </dict>
    </plist>
    EOS
  end

  test do
    system "#{bin}/kdig", "www.knot-dns.cz"
    system "#{bin}/khost", "brew.sh"
    system "#{sbin}/knotc", "-c", "#{etc}/knot.conf", "checkconf"
  end
end
