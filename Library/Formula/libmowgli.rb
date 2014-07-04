require 'formula'

class Libmowgli < Formula
  homepage 'http://atheme.org/projects/libmowgli.html'
  url 'http://distfiles.atheme.org/libmowgli-1.0.0.tar.gz'
  sha1 '403473582e3086c1acaafed59b9915f29a5d0ce0'

  bottle do
    cellar :any
    sha1 "b76fc28dec755183ad47fce6333147a66ddd8ba2" => :mavericks
    sha1 "eebe9cc5140624abc8a4cf7045b2c851d825a203" => :mountain_lion
    sha1 "3fbb392283fb93a03803ff4bf76b1149a7a57025" => :lion
  end

  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <mowgli.h>

      int main(int argc, char *argv[]) {
        char buf[65535];
        mowgli_random_t *r = mowgli_random_create();
        mowgli_formatter_format(buf, 65535, "%1! %2 %3 %4.",\
                    "sdpb", "Hello World", mowgli_random_int(r),\
                    0xDEADBEEF, TRUE);
        puts(buf);
        mowgli_object_unref(r);
        return EXIT_SUCCESS;
      }
    EOS
    system ENV.cc, "-I#{include}/libmowgli", "-o", "test", "test.c", "-lmowgli"
    system "./test"
  end
end
