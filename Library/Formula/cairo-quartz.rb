require 'formula'

# Use a mirror because of:
# http://lists.cairographics.org/archives/cairo/2012-September/023454.html

class CairoQuartz < Formula
  homepage 'http://cairographics.org/'
  url 'http://cairographics.org/releases/cairo-1.12.16.tar.xz'
  mirror 'https://downloads.sourceforge.net/project/machomebrew/mirror/cairo-1.12.16.tar.xz'
  sha256 '2505959eb3f1de3e1841023b61585bfd35684b9733c7b6a3643f4f4cbde6d846'
  revision 1

  keg_only :provided_pre_mountain_lion

  option :universal

  depends_on 'pkg-config' => :build
  depends_on 'freetype'
  depends_on 'fontconfig'
  depends_on 'libpng'
  depends_on 'pixman'
  depends_on 'glib'

  def install
    ENV.universal_binary if build.universal?

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-gobject=yes
      --enable-xlib=no
      --enable-xlib-xrender=no
      --enable-quartz-image
    ]

    args << '--enable-xcb=no' if MacOS.version <= :leopard

    system "./configure", *args
    system "make install"
  end
end
