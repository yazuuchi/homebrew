class Arangodb < Formula
  desc "Universal open-source database with a flexible data model"
  homepage "https://www.arangodb.com/"
  url "https://www.arangodb.com/repositories/Source/ArangoDB-2.8.1.tar.gz"
  sha256 "c5ddfcd33aa935d51085ecd5a52df6872d06fc5c09f645526992a7ba7d5ba985"

  head "https://github.com/arangodb/arangodb.git", :branch => "unstable"

  bottle do
    sha256 "e760352be0104bb2903e53062a111df3a34e46b8e59ed8c56f51b88826d04a46" => :el_capitan
    sha256 "101dc0d14e5fb3aeeea7262a0e69dfe90cfc8026538c0030c25d95a0d21cb868" => :yosemite
    sha256 "6f88c911eb5b1279eb98dd85d68a96521245b0c07dbfc47b97142352af6a31c7" => :mavericks
  end

  depends_on "go" => :build
  depends_on "openssl"

  needs :cxx11

  fails_with :clang do
    build 600
    cause "Fails with compile errors"
  end

  def install
    # clang on 10.8 will still try to build against libstdc++,
    # which fails because it doesn't have the C++0x features
    # arangodb requires.
    ENV.libcxx

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-relative
      --datadir=#{share}
      --localstatedir=#{var}
    ]

    args << "--program-suffix=-unstable" if build.head?

    system "./configure", *args
    system "make", "install"
  end

  def post_install
    (var/"arangodb").mkpath
    (var/"log/arangodb").mkpath

    system "#{sbin}/arangod" + (build.head? ? "-unstable" : ""), "--upgrade", "--log.file", "-"
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/arangodb/sbin/arangod" + (build.head? ? "-unstable" : "") + " --log.file -"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_sbin}/arangod</string>
          <string>-c</string>
          <string>#{etc}/arangodb/arangod.conf</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
    EOS
  end
end
