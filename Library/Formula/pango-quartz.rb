require 'formula'

class PangoQuartz < Formula
  homepage "http://www.pango.org/"
  url "http://ftp.gnome.org/pub/GNOME/sources/pango/1.36/pango-1.36.6.tar.xz"
  sha256 "4c53c752823723875078b91340f32136aadb99e91c0f6483f024f978a02c8624"

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'cairo-quartz'
  depends_on 'harfbuzz-quartz'
  depends_on 'fontconfig'
  depends_on 'gobject-introspection'

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-man
      --with-html-dir=#{share}/doc
      --enable-introspection=yes
      --without-xft
    ]

    system "./configure", *args
    system "make"
    system "make install"
  end

  test do
    system "#{bin}/pango-querymodules", "--version"
  end
end
