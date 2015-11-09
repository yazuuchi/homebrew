class Sfcgal < Formula
  desc "C++ wrapper library around CGAL"
  homepage "http://sfcgal.org/"
  url "https://github.com/Oslandia/SFCGAL/archive/v1.2.0.tar.gz"
  sha256 "aeab3ddd7b4eff2b9b6b365ca1731de693d7a788914d4190f444ef59dead5a47"

  bottle do
    sha256 "3b0c29e4702a59acb4443d494b7c8f216afac1efc028045f725ed0f0851ca8fd" => :el_capitan
    sha256 "7f8f7058a80e1cb15b0e518f662686dc149b95169f44a1370f042e758d4953bf" => :yosemite
    sha256 "9ef9f97f69537662765306beb5f8387e79f3426b3f405791a2f56b3cf94e8468" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cgal"
  depends_on "gmp"
  depends_on "mpfr"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_equal prefix.to_s, shell_output("#{bin}/sfcgal-config --prefix").strip
  end
end
