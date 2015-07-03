class GtkxQuartz < Formula
  desc "GUI toolkit"
  homepage "http://gtk.org/"
  url "https://download.gnome.org/sources/gtk+/2.24/gtk+-2.24.28.tar.xz"
  sha256 "b2c6441e98bc5232e5f9bba6965075dcf580a8726398f7374d39f90b88ed4656"
  revision 1

  depends_on 'pkg-config' => :build
  depends_on 'gdk-pixbuf'
  depends_on 'jasper' => :optional
  depends_on 'atk'
  depends_on 'pango-quartz'
  depends_on 'gobject-introspection'

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def install
    args = ["--disable-dependency-tracking",
            "--disable-silent-rules",
            "--prefix=#{prefix}",
            "--disable-glibtest",
            "--enable-introspection=yes",
            "--disable-visibility",
            "--with-gdktarget=quartz",
            "--enable-quartz-relocation" ]

    system "./configure", *args
    system "make install"
  end
end
