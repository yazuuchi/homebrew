require 'formula'

class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage 'http://homebank.free.fr'
  url 'http://homebank.free.fr/public/homebank-5.0.3.tar.gz'
  sha256 'eac04a19f5d7644a5bf254a22f737d562b41503f280e339192f39745bf0d7839'

  bottle do
    sha256 "6f3e5c28cdcf4b4c3d38b179d85bcf2c975cd45733e1a4a0a055865dba0e732a" => :yosemite
    sha256 "a99b3db94aa8d5bdad8e01400622522b45ddbe116b04ead09e5a61be6efec539" => :mavericks
    sha256 "3cc8e24062a1ec1795bacc7d99b3f42a215780e3bf6575190299b0d55fe9e8cc" => :mountain_lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'gettext'
  depends_on 'gtk+3'
  depends_on 'gnome-icon-theme'
  depends_on 'hicolor-icon-theme'
  depends_on 'freetype'
  depends_on 'fontconfig'
  depends_on 'libofx' => :optional

  def install
    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}"]
    args << "--with-ofx" if build.with? 'libofx'

    system "./configure", *args
    chmod 0755, "./install-sh"
    system "make install"
  end
end
