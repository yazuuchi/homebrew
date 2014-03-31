require 'formula'

class Libpano < Formula
  homepage 'http://panotools.sourceforge.net/'
#  url 'https://downloads.sourceforge.net/project/panotools/libpano13/libpano13-2.9.18/libpano13-2.9.18.tar.gz'
#  version '13-2.9.18'
#  sha1 '23849bdbdfc9176a2b53d157e58bd24aa0e7276e'
#  revision 1

  url 'https://downloads.sourceforge.net/project/panotools/libpano13/libpano13-2.9.19/libpano13-2.9.19_beta1.tar.gz'
  version '13-2.9.19_beta1'
  sha1 '695d6b26112ee18f3783b826e8c1c645f1b4ad2b'

  depends_on 'libpng'
  depends_on 'jpeg'
  depends_on 'libtiff'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
