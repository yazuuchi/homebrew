require 'formula'

class Mozjpeg < Formula
  homepage 'https://github.com/mozilla/mozjpeg'
  url 'https://github.com/mozilla/mozjpeg/archive/v1.0.tar.gz'
  sha1 '13c127ba6387b6b96736c22e0166112f6f8959b3'

  depends_on 'nasm' => :build if MacOS.prefer_64_bit?
  depends_on :autoconf
  depends_on :automake
  depends_on :libtool

  keg_only "mozjpeg is not linked to prevent conflicts with the standard libjpeg."

  def install
    args = ["--disable-dependency-tracking", "--prefix=#{prefix}", "--with-jpeg8", "--mandir=#{man}"]
    if MacOS.prefer_64_bit?
      args << "--host=x86_64-apple-darwin"
      # Auto-detect our 64-bit nasm
      args << "NASM=#{Formula["nasm"].bin}/nasm"
    end

    system 'autoreconf', '-fiv'
    system "./configure", *args
    system 'make'
    ENV.j1 # Stops a race condition error: file exists
    system "make install"
  end

  test do
    system "#{bin}/jpegtran", "-crop", "500x500+200+500",
                              "-transpose", "-perfect",
                              "-outfile", "test.jpg",
                              "/System/Library/CoreServices/DefaultDesktop.jpg"
  end
end
