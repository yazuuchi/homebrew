require 'formula'

class Libpano < Formula
  homepage 'http://panotools.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/panotools/libpano13/libpano13-2.9.19/libpano13-2.9.19.tar.gz'
  version '13-2.9.19'
  sha1 '85d8d94c96780fa5b6df2c2e4929f8d20557f128'
  bottle do
    cellar :any
    sha1 "b1e5da01e08bec1f5ca739a85a7d4c979bca21d6" => :yosemite
    sha1 "ff85fcab7a27810d027116abaccf9362101780c9" => :mavericks
    sha1 "0ea739e0ad708cc3d48d48eb542cb726e705ea2a" => :mountain_lion
  end

  revision 1

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
