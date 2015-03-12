require "formula"

class EmacsQuartz < Formula
  homepage "https://www.gnu.org/software/emacs/"

  stable do
    url "http://ftpmirror.gnu.org/emacs/emacs-24.4.tar.xz"
    mirror "https://ftp.gnu.org/pub/gnu/emacs/emacs-24.4.tar.xz"
    sha256 "47e391170db4ca0a3c724530c7050655f6d573a711956b4cd84693c194a9d4fd"
    # Fix ns-antialias-text, broken in 24.4, from upstream:
    # https://github.com/emacs-mirror/emacs/commit/604a4d21ead40691afe3efe13f0ba1000b2cd61a
    # http://debbugs.gnu.org/cgi/bugreport.cgi?bug=18876

    patch do
      url 'https://gist.githubusercontent.com/scotchi/66edaf426d7375c0f061/raw/4c5229a8a719f81fa6bd2e1e0c85d10b6f635765/emacs-fix-ns-antialias-text-mac-os.patch'
      sha1 'b63eab599a7ce69de03629494a727f45b310c166'
    end
  end

  option "cocoa", "Build a Cocoa version of emacs"
  option "keep-ctags", "Don't remove the ctags executable that emacs provides"

  head do
    url "http://git.sv.gnu.org/r/emacs.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "d-bus" => :optional
  depends_on "gnutls" => :optional
  depends_on "librsvg-quartz" => :optional
  depends_on "imagemagick-quartz" => :optional
  depends_on "mailutils" => :optional
  depends_on "glib" => :optional

  fails_with :llvm do
    build 2334
    cause "Duplicate symbol errors while linking."
  end

  def install
    # HEAD builds blow up when built in parallel as of April 20 2012
    # FIXME is this still necessary? It's been more than two years, surely any
    # race conditions would have made it into release by now.
    ENV.deparallelize unless build.stable?

    args = ["--prefix=#{prefix}",
            "--enable-locallisppath=#{HOMEBREW_PREFIX}/share/emacs/site-lisp",
            "--infodir=#{info}/emacs"]
    args << "--with-file-notification=gfile" if build.with? "glib"
    if build.with? "d-bus"
      args << "--with-dbus"
    else
      args << "--without-dbus"
    end
    if build.with? "gnutls"
      args << "--with-gnutls"
    else
      args << "--without-gnutls"
    end
    args << "--with-rsvg" if build.with? "librsvg-quartz"
    args << "--with-imagemagick" if build.with? "imagemagick-quartz"
    args << "--without-popmail" if build.with? "mailutils"

    system "./autogen.sh" unless build.stable?

    if build.include? "cocoa"
      args << "--with-ns" << "--disable-ns-self-contained"
      system "./configure", *args
      system "make"
      system "make", "install"
      prefix.install "nextstep/Emacs.app"

      # Replace the symlink with one that avoids starting Cocoa.
      (bin/"emacs").unlink # Kill the existing symlink
      (bin/"emacs").write <<-EOS.undent
        #!/bin/bash
        exec #{prefix}/Emacs.app/Contents/MacOS/Emacs -nw  "$@"
      EOS
    else
      args << "--without-x"

      system "./configure", *args
      system "make"
      system "make", "install"
    end

    # Follow MacPorts and don't install ctags from Emacs. This allows Vim
    # and Emacs and ctags to play together without violence.
    unless build.include? "keep-ctags"
      (bin/"ctags").unlink
      (man1/"ctags.1.gz").unlink
    end
  end

  def caveats
    if build.include? "cocoa" then <<-EOS.undent
      A command line wrapper for the cocoa app was installed to:
        #{bin}/emacs
      EOS
    end
  end

  test do
    assert_equal "4", shell_output("#{bin}/emacs --batch --eval=\"(print (+ 2 2))\"").strip
  end
end
