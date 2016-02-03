require "language/go"

class Deisctl < Formula
  desc "Deis Control Utility"
  homepage "http://deis.io/"
  url "https://github.com/deis/deis/archive/v1.12.2.tar.gz"
  sha256 "48aa8f81697b213bd25e95bc2065f7c0dc75e824d7420e71856e102cc16a5229"

  bottle do
    cellar :any_skip_relocation
    sha256 "0b87222a22e030527e1a0d323cd8a83f96ab832cd9c99dc1c488ced7b644f137" => :el_capitan
    sha256 "982250bc46e2671adfe12b75b53726d1d27440b5d2b70e02f003cbd9801e3d84" => :yosemite
    sha256 "ed153dd8ce280c4bb58d623bb8bc74607b70b3ccd9a762543767bc8abb372632" => :mavericks
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  go_resource "github.com/docopt/docopt-go" do
    url "https://github.com/docopt/docopt-go.git", :revision => "854c423c810880e30b9fecdabb12d54f4a92f9bb"
  end

  go_resource "github.com/coreos/go-etcd" do
    url "https://github.com/coreos/go-etcd.git", :revision => "c904d7032a70da6551c43929f199244f6a45f4c1"
  end

  go_resource "github.com/coreos/fleet" do
    url "https://github.com/coreos/fleet.git", :tag => "v0.9.2", :revision => "e0f7a2316dc6ae610979598c4efe127ac8ff1ae9"
  end

  go_resource "github.com/ugorji/go" do
    url "https://github.com/ugorji/go.git", :revision => "821cda7e48749cacf7cad2c6ed01e96457ca7e9d"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p "#{buildpath}/deisctl/Godeps/_workspace/src/github.com/deis"
    ln_s buildpath, "#{buildpath}/deisctl/Godeps/_workspace/src/github.com/deis/deis"

    Language::Go.stage_deps resources, buildpath/"src"

    cd "deisctl" do
      system "godep", "go", "build", "-a", "-ldflags", "-s", "-o", "dist/deisctl"
      bin.install "dist/deisctl"
    end
  end

  test do
    system bin/"deisctl", "help"
  end
end
