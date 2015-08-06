class Sdl2Mixer < Formula
  desc "Sample multi-channel audio mixer library"
  homepage "http://www.libsdl.org/projects/SDL_mixer/"
  url "http://www.libsdl.org/projects/SDL_mixer/release/SDL2_mixer-2.0.0.tar.gz"
  sha256 "a8ce0e161793791adeff258ca6214267fdd41b3c073d2581cd5265c8646f725b"

  head "http://hg.libsdl.org/SDL_mixer", :using => :hg

  depends_on "pkg-config" => :build
  depends_on "sdl2"
  depends_on "flac" => :optional
  depends_on "libmikmod" => :optional
  depends_on "libvorbis" => :optional

  option :universal

  def install
    ENV.universal_binary if build.universal?
    inreplace "SDL2_mixer.pc.in", "@prefix@", HOMEBREW_PREFIX

    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make", "install"
  end
end
