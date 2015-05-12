class PstoeditQuartz < Formula
  homepage "http://www.pstoedit.net"
  url "https://downloads.sourceforge.net/project/pstoedit/pstoedit/3.70/pstoedit-3.70.tar.gz"
  sha256 "06b86113f7847cbcfd4e0623921a8763143bbcaef9f9098e6def650d1ff8138c"

  depends_on "pkg-config" => :build
  depends_on "plotutils"
  depends_on "ghostscript"
  depends_on "imagemagick-quartz"
  depends_on "xz" if MacOS.version < :mavericks

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"pstoedit", "-f", "pdf", test_fixtures("test.ps"), "test.pdf"
    assert File.exist?("test.pdf")
  end
end
