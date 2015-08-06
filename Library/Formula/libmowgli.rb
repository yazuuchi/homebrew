class Libmowgli < Formula
  homepage 'http://atheme.org/Project/mowgli'
  url 'https://github.com/yazuuchi/libmowgli/archive/libmowgli-1.0.0.tar.gz'
  sha1 'c939f1e87844c1b43a6a1f254a458c0b4dc32d98'

  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-openssl=#{Formula["openssl"].opt_prefix}"
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
