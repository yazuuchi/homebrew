class Aap < Formula
  desc "Aap is a make-like tool to download, build, and install software"
  homepage "http://www.a-a-p.org"
  url "https://downloads.sourceforge.net/project/a-a-p/Aap/1.093/aap-1.093.zip"
  sha256 "7a6c6c4a819a8379e60c679fe0c3f93eb1b74204cd7cc1c158263f4b34943001"

  bottle do
    sha256 "2a0ac5d749435a00a40366cbbf0438e7cc29579d4ea73b4491743d34d53dafad" => :yosemite
    sha256 "3044bc85097466a3b88dd7811602d8494f2afe6e1f6c98170056d2e52ca55094" => :mavericks
    sha256 "250cbd3d70ba5d0972c625e5045a019b7ef53d07ecf5da9f9ead3e783b0bced0" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    # Aap only installs "man" at top level. This moves it under share/,
    # which OS X and Homebrew use by default.
    # Upstream bug report: http://sourceforge.net/p/a-a-p/mailman/message/34146703/
    inreplace "main.aap", "mandir = $PREFIX/man/man1", "mandir = $PREFIX/share/man/man1"

    # Aap is designed to install using itself
    system "./aap", "install", "PREFIX=#{prefix}"
  end

  test do
    # A dummy target definition
    (testpath/"main.aap").write("dummy:\n\t:print OK\n")
    system "#{bin}/aap", "dummy"
  end
end
