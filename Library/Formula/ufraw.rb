class Ufraw < Formula
  desc "Unidentified Flying RAW: RAW image processing utility"
  homepage "http://ufraw.sourceforge.net"
  url "https://downloads.sourceforge.net/project/ufraw/ufraw/ufraw-0.22/ufraw-0.22.tar.gz"
  sha256 "f7abd28ce587db2a74b4c54149bd8a2523a7ddc09bedf4f923246ff0ae09a25e"

  bottle do
    sha256 "5462d1df3236f497fbae4171b743e598107224abce9ba274ef8c783153c3e41d" => :el_capitan
    sha256 "21f29f6ffe796c76d3d47ba11923f61c9cc69980bb7175ad24ea9d38e88a95a7" => :yosemite
    sha256 "caf38b978cd614b51eb038f2bdac1cf6c5dfb8697adcae71f7cefceb9a4a2f07" => :mavericks
    sha256 "549b1471b35978a9695f4ea75044f233e782d32628fe0b86e389583e977f7219" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libpng"
  depends_on "dcraw"
  depends_on "glib"
  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "little-cms"
  depends_on "exiv2" => :optional

  fails_with :llvm do
    cause "Segfault while linking"
  end

  patch :DATA

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-gtk",
                          "--without-gimp"
    system "make", "install"
    (share+"pixmaps").rmtree
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ufraw-batch --version 2>&1")
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
