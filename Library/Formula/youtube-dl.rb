# Please only update to versions that are published on PyPi as there are too
# many releases for us to update to every single one:
# https://pypi.python.org/pypi/youtube_dl
class YoutubeDl < Formula
  desc "Download YouTube videos from the command-line"
  homepage "https://rg3.github.io/youtube-dl/"
  url "https://yt-dl.org/downloads/2015.12.13/youtube-dl-2015.12.13.tar.gz"
  sha256 "9c788925865ff559b6c9f124d35aed1125046efda7c6a386f0da59d4eac2ead8"

  bottle do
    cellar :any_skip_relocation
    sha256 "6e6b60b40ad7d41878efff70e18d03044766f4c31f3efe75b1d421f10cff6624" => :el_capitan
    sha256 "db61cb38c9865b1a16471f3624617af4c5b8305fe37e4de077edb60e36127995" => :yosemite
    sha256 "5237a49719cc277e06a12f587a788935d957b6b56c96414eaf8c2e6399227cf0" => :mavericks
  end

  head do
    url "https://github.com/rg3/youtube-dl.git"
    depends_on "pandoc" => :build
  end

  depends_on "rtmpdump" => :optional

  def install
    system "make", "PREFIX=#{prefix}"
    bin.install "youtube-dl"
    man1.install "youtube-dl.1"
    bash_completion.install "youtube-dl.bash-completion"
    zsh_completion.install "youtube-dl.zsh" => "_youtube-dl"
    fish_completion.install "youtube-dl.fish"
  end

  def caveats
    "To use post-processing options, `brew install ffmpeg` or `brew install libav`."
  end

  test do
    system "#{bin}/youtube-dl", "--simulate", "https://www.youtube.com/watch?v=he2a4xK8ctk"
    system "#{bin}/youtube-dl", "--simulate", "--yes-playlist", "https://www.youtube.com/watch?v=AEhULv4ruL4&list=PLZdCLR02grLrl5ie970A24kvti21hGiOf"
  end
end
