require "formula"

class HarfbuzzQuartz < Formula
  homepage "http://www.freedesktop.org/wiki/Software/HarfBuzz"
  url "http://www.freedesktop.org/software/harfbuzz/release/harfbuzz-0.9.34.tar.bz2"
  sha1 "8a8cdbeaf1622459864180fbf453e3ab7343f338"

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "cairo-quartz"
  depends_on "icu4c" => :recommended
  depends_on "freetype"

  def install
    args = %W[--disable-dependency-tracking --prefix=#{prefix}]
    args << "--with-icu" if build.with? "icu4c"
    system "./configure", *args
    system "make install"
  end
end
