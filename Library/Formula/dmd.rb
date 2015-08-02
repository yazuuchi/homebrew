class Dmd < Formula
  desc "D programming language compiler for OS X"
  homepage "http://dlang.org"

  stable do
    url "https://github.com/D-Programming-Language/dmd/archive/v2.067.1.tar.gz"
    sha256 "526860456d181bb39ebdb7fb2bbb13e3afe62ec07c588eb5a5e8b8b61627ed8f"

    resource "druntime" do
      url "https://github.com/D-Programming-Language/druntime/archive/v2.067.1.tar.gz"
      sha256 "bf4628f367e7ec968ce36d09faffbb84b7444e376a005494d98654e6b5193df6"
    end

    resource "phobos" do
      url "https://github.com/D-Programming-Language/phobos/archive/v2.067.1.tar.gz"
      sha256 "c2afc15a780768809d8dcaa7cc740a2b4417a7242b8059cd64025af7ab9ce446"
    end

    resource "tools" do
      url "https://github.com/D-Programming-Language/tools/archive/v2.067.1.tar.gz"
      sha256 "756b55ca855830e0144aced12e4c48af4f44c29f0e55a43529bf86aa09a0ae66"
    end
  end

  bottle do
    revision 1
    sha256 "6e372cff4697140f17ee046011e2565610c66e2d104634a2cedc099ea1b7fdf1" => :yosemite
    sha256 "57594a3b188b988e54347abf4a20abfa90aebcadd12a504a885bb43af77bf463" => :mavericks
    sha256 "c4959506472c4d188a047d330bcd5e2e0b63c645cd7735ba12c484233ec0f736" => :mountain_lion
  end

  devel do
    url "https://github.com/D-Programming-Language/dmd/archive/v2.068.0-b2.tar.gz"
    version "2.068.0-b2"
    sha256 "7daaae9c9f97e7dd9ebf036955169e33bc22cd51b481243e70cf5d885387bc6a"

    resource "druntime" do
      url "https://github.com/D-Programming-Language/druntime/archive/v2.068.0-b2.tar.gz"
      sha256 "71cf90138fd7c71cc44dd2edc8b6892f827164c5e175fbe019bc8e9bc3f3dd4d"
    end

    resource "phobos" do
      url "https://github.com/D-Programming-Language/phobos/archive/v2.068.0-b2.tar.gz"
      sha256 "7bf904f0afb3a3630031c9246fa75eb8c3ed30c552506e7a647f2a746f2a5ed8"
    end

    resource "tools" do
      url "https://github.com/D-Programming-Language/tools/archive/v2.068.0-b2.tar.gz"
      sha256 "d9b7b23ed121284bd8ccf119b30d65b200c893b8509560fb67a0ac9007cc2b43"
    end
  end

  head do
    url "https://github.com/D-Programming-Language/dmd.git"

    resource "druntime" do
      url "https://github.com/D-Programming-Language/druntime.git"
    end

    resource "phobos" do
      url "https://github.com/D-Programming-Language/phobos.git"
    end

    resource "tools" do
      url "https://github.com/D-Programming-Language/tools.git"
    end
  end

  def install
    make_args = ["INSTALL_DIR=#{prefix}", "MODEL=#{Hardware::CPU.bits}", "-f", "posix.mak"]

    system "make", "SYSCONFDIR=#{etc}", "TARGET_CPU=X86", "AUTO_BOOTSTRAP=1", "RELEASE=1", *make_args

    bin.install "src/dmd"
    prefix.install "samples"
    man.install Dir["docs/man/*"]

    # A proper dmd.conf is required for later build steps:
    conf = buildpath/"dmd.conf"
    # Can't use opt_include or opt_lib here because dmd won't have been
    # linked into opt by the time this build runs:
    conf.write <<-EOS.undent
        [Environment]
        DFLAGS=-I#{include}/d2 -L-L#{lib}
        EOS
    etc.install conf
    install_new_dmd_conf

    make_args.unshift "DMD=#{bin}/dmd"

    (buildpath/"druntime").install resource("druntime")
    (buildpath/"phobos").install resource("phobos")

    system "make", "-C", "druntime", *make_args
    system "make", "-C", "phobos", "VERSION=#{buildpath}/VERSION", *make_args

    (include/"d2").install Dir["druntime/import/*"]
    cp_r ["phobos/std", "phobos/etc"], include/"d2"
    lib.install Dir["druntime/lib/*", "phobos/**/libphobos2.a"]

    resource("tools").stage do
      inreplace "posix.mak", "install: $(TOOLS) $(CURL_TOOLS)", "install: $(TOOLS) $(ROOT)/dustmite"
      system "make", "install", *make_args
    end
  end

  # Previous versions of this formula may have left in place an incorrect
  # dmd.conf.  If it differs from the newly generated one, move it out of place
  # and warn the user.
  # This must be idempotent because it may run from both install() and
  # post_install() if the user is running `brew install --build-from-source`.
  def install_new_dmd_conf
    conf = etc/"dmd.conf"

    # If the new file differs from conf, etc.install drops it here:
    new_conf = etc/"dmd.conf.default"
    # Else, we're already using the latest version:
    return unless new_conf.exist?

    backup = etc/"dmd.conf.old"
    opoo "An old dmd.conf was found and will be moved to #{backup}."
    mv conf, backup
    mv new_conf, conf
  end

  def post_install
    install_new_dmd_conf
  end

  test do
    system bin/"dmd", prefix/"samples/hello.d"
    system "./hello"
  end
end
