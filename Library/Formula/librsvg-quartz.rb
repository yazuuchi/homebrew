class LibrsvgQuartz < Formula
  desc "Library to render SVG files using Cairo"
  url "https://download.gnome.org/sources/librsvg/2.40/librsvg-2.40.9.tar.xz"
  sha256 "13964c5d35357552b47d365c34215eee0a63bf0e6059b689f048648c6bf5f43a"
  revision 1

  depends_on 'pkg-config' => :build
  depends_on 'gtk+-quartz'
  depends_on 'libcroco'
  depends_on 'libgsf' => :optional

  def install
    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--disable-Bsymbolic",
            "--enable-tools=yes",
            "--enable-pixbuf-loader=yes",
            "--enable-introspection=no"]

    args << "--enable-svgz" if build.with? 'libgsf'

    system "./configure", *args
    system "make install"
  end
end
