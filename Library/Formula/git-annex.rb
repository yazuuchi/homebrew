require "language/haskell"

class GitAnnex < Formula
  include Language::Haskell::Cabal

  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-5.20150727/git-annex-5.20150727.tar.gz"
  sha256 "9826836bd0eb4e35be8664862405afbf2ff4dff9a643b2f8ec61c295bd16099f"

  bottle do
    sha256 "fcccfd5a002c1a93e38a0d4a34580a194d9b6a2d751e0e067a62866e2bce11c3" => :yosemite
    sha256 "b5d40262da2ce7c12d625bff79b53cf5710323283a7bf4dda1e7f0e02b02cc01" => :mavericks
    sha256 "ef54843a91d6ead2a30b08ac23ad6fc6d993c872ec1eb8121e247299084e7ccc" => :mountain_lion
  end

  option "with-git-union-merge", "Build the git-union-merge tool"

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pkg-config" => :build
  depends_on "gsasl"
  depends_on "libidn"
  depends_on "gnutls"
  depends_on "quvi"

  setup_ghc_compilers

  def install
    cabal_sandbox do
      cabal_install_tools "alex", "happy", "c2hs"
      cabal_install "--only-dependencies"
      cabal_install "--prefix=#{prefix}"

      # this can be made the default behavior again once git-union-merge builds properly when bottling
      if build.with? "git-union-merge"
        system "make", "git-union-merge", "PREFIX=#{prefix}"
        bin.install "git-union-merge"
        system "make", "git-union-merge.1", "PREFIX=#{prefix}"
      end

      system "make", "install-docs", "PREFIX=#{prefix}"
    end
    bin.install_symlink "git-annex" => "git-annex-shell"
    cabal_clean_lib
  end

  test do
    # make sure git can find git-annex
    ENV.prepend_path "PATH", bin
    system "git", "annex", "test"
  end
end
