require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Fd < Formula
  homepage ''
  url 'http://hp.vector.co.jp/authors/VA012337/soft/fd/FD-3.01.tar.gz'
  version '3.01'
  sha1 '064ad86e3396d768c9f4722cdece19e50a3f5e8e'

  # depends_on 'cmake' => :build
#  depends_on :x11 # if your formula requires any X11/XQuartz components

  def install
    # ENV.j1  # if your formula's build system can't parallelize

#    system "./configure", "--disable-debug", "--disable-dependency-tracking",
#                          "--prefix=#{prefix}"
    # system "cmake", ".", *std_cmake_args

   system "make", "PREFIX=#{prefix}"
#   system "make MANTOP=#{man} install"
#   system "make MANTOP=#{man} jcatman"
   system "make install" # if this fails, try separate make/make install steps
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test FD`.
    system "false"
  end
end
