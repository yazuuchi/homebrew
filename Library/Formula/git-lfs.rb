class GitLfs < Formula
  desc "Git extension for versioning large files"
  homepage "https://github.com/github/git-lfs"
  url "https://github.com/github/git-lfs/archive/v1.1.1.tar.gz"
  sha256 "eba7108c3075863d0940982bf6ef06730fbe66741f20fcc31833b07233a7ec4c"

  bottle do
    cellar :any_skip_relocation
    sha256 "796b6ac96d8f0a661029917a7fa6e15581a7e45861d9b760d0cd919054dd2429" => :el_capitan
    sha256 "cfd8df71dbd7adb83baeb579fc75b59b1dc6636cd314ac3022e39f0c40bf141c" => :yosemite
    sha256 "50a0952d58175034a18af59cfc97af4f6c61df2e6a7c33afa10fbf28c0f4a7f7" => :mavericks
  end

  depends_on "go" => :build

  def install
    system "./script/bootstrap"
    bin.install "bin/git-lfs"
  end

  test do
    system "git", "init"
    system "git", "lfs", "track", "test"
    assert_match(/^test filter=lfs/, File.read(".gitattributes"))
  end
end
