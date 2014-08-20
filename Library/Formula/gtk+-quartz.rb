require 'formula'

class GtkxQuartz < Formula
  homepage 'http://gtk.org/'
  url 'http://ftp.gnome.org/pub/gnome/sources/gtk+/2.24/gtk+-2.24.24.tar.xz'
  sha256 '12ceb2e198c82bfb93eb36348b6e9293c8fdcd60786763d04cfec7ebe7ed3d6d'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'jpeg'
  depends_on 'libtiff'
  depends_on 'gdk-pixbuf'
  depends_on 'pango-quartz'
  depends_on 'jasper' => :optional
  depends_on 'atk'
  depends_on 'cairo-quartz'
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
      --disable-glibtest
      --enable-introspection=yes
      --disable-visibility
      --with-gdktarget=quartz
      --enable-quartz-relocation
    ]

    system "./configure", *args
    system "make install"
  end
end
