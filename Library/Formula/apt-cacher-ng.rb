class AptCacherNg < Formula
  desc "Caching proxy"
  homepage "https://www.unix-ag.uni-kl.de/~bloch/acng/"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/a/apt-cacher-ng/apt-cacher-ng_0.8.6.orig.tar.xz"
  mirror "https://mirrors.kernel.org/debian/pool/main/a/apt-cacher-ng/apt-cacher-ng_0.8.6.orig.tar.xz"
  sha256 "255b742d3551fcbfa71b6df4d8892038934812425222a15d085436a4a76b8400"

  bottle do
    revision 1
    sha256 "5775ba1cb6fc3db07e1b83d5c31cc6631d1eb7c9d457a9f41f5a65b64f39d75b" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on :osxfuse => :build
  depends_on "boost" => :build
  depends_on "openssl"
  depends_on "xz" # For LZMA

  needs :cxx11

  def install
    ENV.cxx11

    # https://alioth.debian.org/tracker/index.php?func=detail&aid=315130&group_id=100566&atid=413111
    # All of these cause breakage during compile. Have added a comment to original bug report.
    inreplace "CMakeLists.txt",
      "linkarg -Wl,--as-needed -Wl,-O1 -Wl,--discard-all -Wl,--no-undefined -Wl,--build-id=sha1",
      "linkarg -Wl"

    (var/"spool/apt-cacher-ng").mkpath
    (var/"log").mkpath

    inreplace "conf/acng.conf.in" do |s|
      s.gsub!(/^CacheDir: .*/, "CacheDir: #{var}/spool/apt-cacher-ng")
      s.gsub!(/^LogDir: .*/, "LogDir: #{var}/log")
    end

    system "cmake", ".", *std_cmake_args
    system "make", "apt-cacher-ng"
    system "make", "install"
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>OnDemand</key>
      <false/>
      <key>RunAtLoad</key>
      <true/>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_sbin}/apt-cacher-ng</string>
        <string>-c</string>
        <string>#{etc}/apt-cacher-ng</string>
        <string>foreground=1</string>
      </array>
      <key>ServiceIPC</key>
      <false/>
    </dict>
    </plist>
    EOS
  end

  test do
    (testpath/"var/log").mkpath
    (testpath/"var/spool").mkpath
    logs = "LogDir=#{testpath}/var/log"
    cache = "CacheDir=#{testpath}/var/spool"

    pid = fork do
      exec "#{sbin}/apt-cacher-ng", "-c", "#{etc}/apt-cacher-ng", logs, cache
    end
    sleep 2

    begin
      assert_match(/Not Found or APT Reconfiguration required/, shell_output("curl localhost:3142"))
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
