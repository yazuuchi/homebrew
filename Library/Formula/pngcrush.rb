require "formula"

class Pngcrush < Formula
  homepage "http://pmt.sourceforge.net/pngcrush/"
  url "https://downloads.sourceforge.net/project/pmt/pngcrush/1.7.80/pngcrush-1.7.80.tar.gz"
  sha1 "299650645a675ec1652a8c97d2bc5094ff91ba5c"

  bottle do
    cellar :any
    sha1 "4e9958095e92fc147b0a6a5dcff8a9d3835155b1" => :yosemite
    sha1 "fa65f4af28e0b62f96b5a5696e03968179f8ce27" => :mavericks
    sha1 "7283828aa8237281ff47411dcd586b5d7a732448" => :mountain_lion
  end

  def install
    # Required to enable "-cc" (color counting) option (disabled by default since 1.5.1)
    ENV.append_to_cflags "-DPNGCRUSH_COUNT_COLORS"

    system "make", "CC=#{ENV.cc}",
                   "LD=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "LDFLAGS=#{ENV.ldflags}"
    bin.install "pngcrush"
  end

  test do
    system "#{bin}/pngcrush", test_fixtures("test.png"), "/dev/null"
  end
end
