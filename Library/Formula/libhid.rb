require 'formula'

class Libhid < Formula
  homepage 'http://libhid.alioth.debian.org/'
  url 'http://alioth.debian.org/frs/download.php/file/1958/libhid-0.2.16.tar.gz'
  sha1 '9a25fef674e8f20f97fea6700eb91c21ebbbcc02'

  depends_on 'libusb'
  depends_on 'libusb-compat'

  def patches; DATA; end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-swig"

    system "make install"
  end
end

__END__
--- a/src/Makefile.in   Thu Jan 09 17:29:34 2014 +0900
+++ b/src/Makefile.in   Thu Jan 09 17:35:58 2014 +0900
@@ -39,7 +39,7 @@ POST_UNINSTALL = :
 build_triplet = @build@
 host_triplet = @host@
 @OS_BSD_FALSE@@OS_DARWIN_TRUE@@OS_LINUX_FALSE@@OS_SOLARIS_FALSE@am__append_1 = -no-cpp-precomp
-@OS_BSD_FALSE@@OS_DARWIN_TRUE@@OS_LINUX_FALSE@@OS_SOLARIS_FALSE@am__append_2 = -lIOKit -framework "CoreFoundation"
+@OS_BSD_FALSE@@OS_DARWIN_TRUE@@OS_LINUX_FALSE@@OS_SOLARIS_FALSE@am__append_2 = -framework "CoreFoundation"
 bin_PROGRAMS = libhid-detach-device$(EXEEXT)
 subdir = src
 DIST_COMMON = $(include_HEADERS) $(srcdir)/Makefile.am \
