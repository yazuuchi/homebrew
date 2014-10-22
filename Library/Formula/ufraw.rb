require 'formula'

class Ufraw < Formula
  homepage 'http://ufraw.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/ufraw/ufraw/ufraw-0.20/ufraw-0.20.tar.gz'
  sha1 'f2f456c6ec5ab128433502eae05b82a7ed636f3e'

  bottle do
    sha1 "114f5807e129d36cf97186160ead6003adb5b6fa" => :yosemite
    sha1 "3604acf00a45b6e569b264d2e482626214731ca8" => :mavericks
    sha1 "2ee9849f3b51f2702f67a6626539fcae5a9a6f04" => :mountain_lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'libpng'
  depends_on 'dcraw'
  depends_on 'glib'
  depends_on 'jpeg'
  depends_on 'libtiff'
  depends_on 'little-cms'
  depends_on 'exiv2' => :optional

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
