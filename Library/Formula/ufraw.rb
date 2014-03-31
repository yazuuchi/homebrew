require 'formula'

class Ufraw < Formula
  homepage 'http://ufraw.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/ufraw/ufraw/ufraw-0.19.2/ufraw-0.19.2.tar.gz'
  sha1 '11a607e874eb16453a8f7964e4946a29d18b071d'
  revision 1

  depends_on 'pkg-config' => :build
  depends_on 'libpng'
  depends_on 'dcraw'
  depends_on 'glib'
  depends_on 'jpeg'
  depends_on 'libtiff'
  depends_on 'little-cms'
  depends_on 'exiv2' => :optional

  # Fixes compilation with clang 3.4; fixed upstream
  # http://sourceforge.net/p/ufraw/bugs/365/
  patch :p0 do
    url "https://trac.macports.org/export/115801/trunk/dports/graphics/ufraw/files/cplusplus.patch"
    sha1 "eb6a782625ba99dc2dcdaf574734734d17a75562"
  end

  fails_with :llvm do
    cause "Segfault while linking"
  end

  patch :DATA

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-gtk",
                          "--without-gimp"
    system "make install"
    (share+'pixmaps').rmtree
  end
end

__END__
diff -r 175a62914bc3 -r 67a01c583860 ufraw.h
--- a/ufraw.h	Mon Mar 24 14:54:18 2014 +0900
+++ b/ufraw.h	Mon Mar 24 15:31:55 2014 +0900
@@ -55,28 +55,34 @@
  * UFObject Definitions for ufraw_settings.cc
  */
 
-extern UFName ufWB;
-extern UFName ufPreset;
-extern UFName ufWBFineTuning;
-extern UFName ufTemperature;
-extern UFName ufGreen;
-extern UFName ufChannelMultipliers;
-extern UFName ufLensfunAuto;
-extern UFName ufLensfun;
-extern UFName ufCameraModel;
-extern UFName ufLensModel;
-extern UFName ufFocalLength;
-extern UFName ufAperture;
-extern UFName ufDistance;
-extern UFName ufTCA;
-extern UFName ufVignetting;
-extern UFName ufDistortion;
-extern UFName ufModel;
-extern UFName ufLensGeometry;
-extern UFName ufTargetLensGeometry;
-extern UFName ufRawImage;
-extern UFName ufRawResources;
-extern UFName ufCommandLine;
+#ifdef __cplusplus
+extern "C" {
+#endif
+    extern UFName ufWB;
+    extern UFName ufPreset;
+    extern UFName ufWBFineTuning;
+    extern UFName ufTemperature;
+    extern UFName ufGreen;
+    extern UFName ufChannelMultipliers;
+    extern UFName ufLensfunAuto;
+    extern UFName ufLensfun;
+    extern UFName ufCameraModel;
+    extern UFName ufLensModel;
+    extern UFName ufFocalLength;
+    extern UFName ufAperture;
+    extern UFName ufDistance;
+    extern UFName ufTCA;
+    extern UFName ufVignetting;
+    extern UFName ufDistortion;
+    extern UFName ufModel;
+    extern UFName ufLensGeometry;
+    extern UFName ufTargetLensGeometry;
+    extern UFName ufRawImage;
+    extern UFName ufRawResources;
+    extern UFName ufCommandLine;
+#ifdef __cplusplus
+}
+#endif
 
 #ifdef __cplusplus
 extern "C" {
