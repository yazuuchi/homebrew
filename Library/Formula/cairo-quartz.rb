require 'formula'

# Use a mirror because of:
# http://lists.cairographics.org/archives/cairo/2012-September/023454.html

class CairoQuartz < Formula
  homepage 'http://cairographics.org/'
  url "http://cairographics.org/releases/cairo-1.14.2.tar.xz"
  mirror "http://www.mirrorservice.org/sites/ftp.netbsd.org/pub/pkgsrc/distfiles/cairo-1.14.2.tar.xz"
  sha256 "c919d999ddb1bbbecd4bbe65299ca2abd2079c7e13d224577895afa7005ecceb"

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
