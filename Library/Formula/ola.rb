require "formula"

class Ola < Formula
  desc "Open Lighting Architecture for lighting control information"
  homepage "https://www.openlighting.org/ola/"
  url "https://github.com/OpenLightingProject/ola/releases/download/0.9.6/ola-0.9.6.tar.gz"
  sha256 "e1bbc7ed833d64107f13d64274ff92b0a0dfc6c1e2f6def18c6ad4b6fa2be744"

  bottle do
    sha256 "838e2f7a782fc0666c4e32c2ba4748fafc5187bb1c3dea29cadc08780e3b4163" => :yosemite
    sha256 "f64eb029feb50f4ac0b54866659279af393fa8b3315aa474485de26574e0279b" => :mavericks
    sha256 "55623105858b2c07eab3e9d82171028f224eaefbf03032d58537d48e82317cb7" => :mountain_lion
  end

  head do
    url "https://github.com/OpenLightingProject/ola.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "cppunit"
  depends_on "protobuf-c"
  depends_on "libmicrohttpd"
  depends_on "libusb"
  depends_on "liblo"
  depends_on "ossp-uuid"
  depends_on :python => :optional
  depends_on "doxygen" => :optional

  def install
    ENV.universal_binary if build.universal?

    args = %W[
      --disable-fatal-warnings
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    args << "--enable-python-libs" if build.with? "python"
    args << "--enable-doxygen-man" if build.with? "doxygen"

    system "autoreconf", "-i" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"ola_plugin_info"
  end
end
