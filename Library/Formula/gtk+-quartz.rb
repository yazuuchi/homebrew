require 'formula'

class GtkxQuartz < Formula
  homepage "http://gtk.org/"
  url "https://download.gnome.org/sources/gtk+/2.24/gtk+-2.24.27.tar.xz"
  sha256 "20cb10cae43999732a9af2e9aac4d1adebf2a9c2e1ba147050976abca5cd24f4"

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
