require "language/go"

class ThePlatinumSearcher < Formula
  desc "Multi-platform code-search similar to ack and ag"
  homepage "https://github.com/monochromegane/the_platinum_searcher"
  url "https://github.com/monochromegane/the_platinum_searcher/archive/v2.0.0.tar.gz"
  sha256 "0a4d295a11a99c99265ff45388bdf4f20e6fd3655c36d4c85fa0eb3f45107d99"
  head "https://github.com/monochromegane/the_platinum_searcher.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "66316240fa3342e5ec72ccf4111837f684e05f5c6132f390ca79f6583101aaaa" => :el_capitan
    sha256 "bf9e3ecdf167409775d7c420b96d394328c97023b8410069f9c327bf4d4d1a3a" => :yosemite
    sha256 "d0c2997cf66f0adbf5e6f19252c5e50d418a993661aabc06694ed6eb1bba93da" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/jessevdk/go-flags" do
    url "https://github.com/jessevdk/go-flags.git",
        :revision => "0a28dbe50f23d8fce6b016975b964cfe7b97a20a"
  end

  go_resource "github.com/monochromegane/terminal" do
    url "https://github.com/monochromegane/terminal.git",
        :revision => "6d255869fb99937f1f287bd1fe3a034c6c4f68f6"
  end

  go_resource "github.com/shiena/ansicolor" do
    url "https://github.com/shiena/ansicolor.git",
        :revision => "691ac7d4ac14053de3cbe16e07b79246300db97d"
  end

  go_resource "golang.org/x/text" do
    url "https://github.com/golang/text.git",
        :revision => "c980adc4a823548817b9c47d38c6ca6b7d7d8b6a"
  end

  go_resource "github.com/BurntSushi/toml" do
    url "https://github.com/BurntSushi/toml.git",
        :revision => "056c9bc7be7190eaa7715723883caffa5f8fa3e4"
  end

  go_resource "github.com/monochromegane/conflag" do
    url "https://github.com/monochromegane/conflag.git",
        :revision => "6d68c9aa4183844ddc1655481798fe4d90d483e9"
  end

  go_resource "github.com/monochromegane/go-gitignore" do
    url "https://github.com/monochromegane/go-gitignore.git",
        :revision => "1ffeeb6761d4574b515b2cfede9073d2eac5fbfc"
  end

  go_resource "github.com/monochromegane/go-home" do
    url "https://github.com/monochromegane/go-home.git",
        :revision => "25d9dda593924a11ea52e4ffbc8abdb0dbe96401"
  end

  go_resource "gopkg.in/yaml.v2" do
    url "https://gopkg.in/yaml.v2.git",
        :revision => "c1cd2254a6dd314c9d73c338c12688c9325d85c6"
  end

  def install
    mkdir_p buildpath/"src/github.com/monochromegane"
    ln_s buildpath, buildpath/"src/github.com/monochromegane/the_platinum_searcher"

    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", bin/"pt", "cmd/pt/main.go"
  end

  test do
    path = testpath/"hello_world.txt"
    path.write "Hello World!"

    lines = `#{bin}/pt 'Hello World!' #{path}`.strip.split(":")
    assert_equal "Hello World!", lines[2]
  end
end
