require 'formula'

class Libtiff < Formula
  homepage 'http://www.remotesensing.org/libtiff/'
  url 'ftp://ftp.remotesensing.org/pub/libtiff/tiff-4.0.3.tar.gz'
  mirror 'http://download.osgeo.org/libtiff/tiff-4.0.3.tar.gz'
  sha256 'ea1aebe282319537fb2d4d7805f478dd4e0e05c33d0928baba76a7c963684872'

#  bottle do
#    cellar :any
#    sha1 "8e2a7f7509689733c0762e01410e247b7ccb98af" => :mavericks
#    sha1 "611e3478187bbcdb5f35970914ee4fe269aeb585" => :mountain_lion
#    sha1 "889158ea146de39f42a489b18af4321004cd54d8" => :lion
#  end

  option :universal
  option :cxx11

  depends_on 'jpeg'

  patch :DATA

  def install
    ENV.universal_binary if build.universal?
    ENV.cxx11 if build.cxx11?
    jpeg = Formula["jpeg"].opt_prefix
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-x",
                          "--disable-lzma",
                          "--with-jpeg-include-dir=#{jpeg}/include",
                          "--with-jpeg-lib-dir=#{jpeg}/lib"
    system "make install"
  end
end

__END__
diff -r 95682347e175 configure
--- a/configure	Fri May 23 16:29:15 2014 +0900
+++ b/configure	Fri May 23 16:32:02 2014 +0900
@@ -17042,7 +17042,7 @@ fi
 $as_echo "$INT64_T" >&6; }
 
 cat >>confdefs.h <<_ACEOF
-#define TIFF_INT64_T $INT64_T
+#define TIFF_INT64_T int64_t
 _ACEOF
 
 
@@ -17076,7 +17076,7 @@ fi
 $as_echo "$UINT64_T" >&6; }
 
 cat >>confdefs.h <<_ACEOF
-#define TIFF_UINT64_T $UINT64_T
+#define TIFF_UINT64_T uint64_t
 _ACEOF
 
 
diff -r 95682347e175 configure.ac
--- a/configure.ac	Fri May 23 16:29:15 2014 +0900
+++ b/configure.ac	Fri May 23 16:32:02 2014 +0900
@@ -290,7 +290,7 @@ fi
 
 
 AC_MSG_RESULT($INT64_T)
-AC_DEFINE_UNQUOTED(TIFF_INT64_T,$INT64_T,[Signed 64-bit type])
+AC_DEFINE_UNQUOTED(TIFF_INT64_T,[int64_t],[Signed 64-bit type])
 AC_DEFINE_UNQUOTED(TIFF_INT64_FORMAT,$INT64_FORMAT,[Signed 64-bit type formatter])
 
 AC_MSG_CHECKING(for unsigned 64-bit type)
@@ -314,7 +314,7 @@ then
   esac
 fi
 AC_MSG_RESULT($UINT64_T)
-AC_DEFINE_UNQUOTED(TIFF_UINT64_T,$UINT64_T,[Unsigned 64-bit type])
+AC_DEFINE_UNQUOTED(TIFF_UINT64_T,[uint64_t],[Unsigned 64-bit type])
 AC_DEFINE_UNQUOTED(TIFF_UINT64_FORMAT,$UINT64_FORMAT,[Unsigned 64-bit type formatter])
 
 # Determine TIFF equivalent of ssize_t
diff -r 95682347e175 libtiff/tif_config.h.in
--- a/libtiff/tif_config.h.in	Fri May 23 16:29:15 2014 +0900
+++ b/libtiff/tif_config.h.in	Fri May 23 16:32:02 2014 +0900
@@ -1,5 +1,7 @@
 /* libtiff/tif_config.h.in.  Generated from configure.ac by autoheader.  */
 
+#include <stdint.h>
+
 /* Define if building universal (internal helper macro) */
 #undef AC_APPLE_UNIVERSAL_BUILD
 
diff -r 95682347e175 libtiff/tiffconf.h.in
--- a/libtiff/tiffconf.h.in	Fri May 23 16:29:15 2014 +0900
+++ b/libtiff/tiffconf.h.in	Fri May 23 16:32:02 2014 +0900
@@ -7,6 +7,8 @@
 #ifndef _TIFFCONF_
 #define _TIFFCONF_
 
+#include <stdint.h>
+
 /* Signed 16-bit type */
 #undef TIFF_INT16_T
 
