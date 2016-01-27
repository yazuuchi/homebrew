class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git", :tag => "0.7.0", :revision => "2241a1e4dfa93a5e9373493d4b6a72078d2bae2c"
  head "https://github.com/realm/SwiftLint.git"

  bottle do
    cellar :any
    sha256 "7f5346b70fd47ca0682f22211a3ebdf58158b6ca86162c16d3452092d303559a" => :el_capitan
    sha256 "227e516c25b2c685a7800d10c618b82b67e8628d9918e983646539d1112fa6fb" => :yosemite
  end

  depends_on :xcode => ["7.1", :build]

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SwiftLint.dst"
  end

  test do
    (testpath/"Test.swift").write "import Foundation\n"
    system "#{bin}/swiftlint"
  end
end
