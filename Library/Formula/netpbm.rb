require 'formula'

class Netpbm < Formula
  homepage 'http://netpbm.sourceforge.net'
  # Maintainers: Look at http://netpbm.svn.sourceforge.net/viewvc/netpbm/
  # for versions and matching revisions
  url 'svn+http://svn.code.sf.net/p/netpbm/code/advanced/', :revision => 2277
  version '10.67.05'

  head 'http://svn.code.sf.net/p/netpbm/code/trunk'

  bottle do
    cellar :any
    sha1 "6b5d4ba6089ab5a4665c46ade6fba04fb8f99f42" => :mavericks
    sha1 "3b4f7ba452a93956aa2fb8655d2b0066195c47d3" => :mountain_lion
    sha1 "656e30aee6d73d7c8910d801d6c24cdaf7afe2ed" => :lion
  end

  option :universal

  depends_on "libtiff"
  depends_on "jasper"
  depends_on "libpng"

  def install
    ENV.universal_binary if build.universal?

    system "cp", "config.mk.in", "config.mk"

    inreplace "config.mk" do |s|
      s.remove_make_var! "CC"
      s.change_make_var! "CFLAGS_SHLIB", "-fno-common"
      s.change_make_var! "NETPBMLIBTYPE", "dylib"
      s.change_make_var! "NETPBMLIBSUFFIX", "dylib"
      s.change_make_var! "LDSHLIB", "--shared -o $(SONAME)"
      s.change_make_var! "TIFFLIB", "-ltiff"
      s.change_make_var! "JPEGLIB", "-ljpeg"
      s.change_make_var! "PNGLIB", "-lpng"
      s.change_make_var! "ZLIB", "-lz"
      s.change_make_var! "JASPERLIB", "-ljasper"
      s.change_make_var! "JASPERHDR_DIR", "#{Formula["jasper"].opt_include}/jasper"
    end

    ENV.deparallelize
    system "make"
    system "make", "package", "pkgdir=#{buildpath}/stage"
    cd 'stage' do
      prefix.install %w{ bin include lib misc }
      # do man pages explicitly; otherwise a junk file is installed in man/web
      man1.install Dir['man/man1/*.1']
      man5.install Dir['man/man5/*.5']
      lib.install Dir['link/*.a']
    end

    (bin/'doc.url').unlink
  end
end
