require 'formula'

class Libpano < Formula
  homepage 'http://panotools.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/panotools/libpano13/libpano13-2.9.19/libpano13-2.9.19_beta1.tar.gz'
  version '13-2.9.19_beta1'
  sha1 '695d6b26112ee18f3783b826e8c1c645f1b4ad2b'

  head 'http://hg.code.sf.net/p/panotools/libpano13', :using => :hg

  depends_on 'libpng'
  depends_on 'jpeg'
  depends_on 'libtiff'

  def install
    if build.head?
      # Link the Mercurial repository into the download directory so
      # build.py can use it to figure out a version number.
      ln_s cached_download + ".hg", ".hg"
      system "autoreconf -fiv"
    end
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
