class Thefuck < Formula
  homepage "https://github.com/nvbn/thefuck"
  url "https://pypi.python.org/packages/source/t/thefuck/thefuck-1.40.tar.gz"
  sha256 "f20262e3b1e59d66ad9cfa5b4fba45737a959789f9a094ea226b455f6c8b1f9e"

  bottle do
    cellar :any
    sha256 "890762ad1d9324ab346cab435dd0d89f8820ee43c68046847fb1218aed9fe246" => :yosemite
    sha256 "8eb332807213eedc8f34e3c60f5305e24d1deb0d1c09907994ca0a05bbb47f66" => :mavericks
    sha256 "ed2b83dd297c9a8ff578f48157cf7740a17e261d167c0f1243580bd6f8767829" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "psutil" do
    url "https://pypi.python.org/packages/source/p/psutil/psutil-2.2.1.tar.gz"
    sha256 "a0e9b96f1946975064724e242ac159f3260db24ffa591c3da0a355361a3a337f"
  end

  resource "pathlib" do
    url "https://pypi.python.org/packages/source/p/pathlib/pathlib-1.0.1.tar.gz"
    sha256 "6940718dfc3eff4258203ad5021090933e5c04707d5ca8cc9e73c94a7894ea9f"
  end

  resource "colorama" do
    url "https://pypi.python.org/packages/source/c/colorama/colorama-0.3.3.tar.gz"
    sha256 "eb21f2ba718fbf357afdfdf6f641ab393901c7ca8d9f37edd0bee4806ffa269c"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha256 "e24052411fc4fbd1f672635537c3fc2330d9481b18c0317695b46259512c91d5"
  end

  def install
    ENV["PYTHONPATH"] = libexec/"vendor/lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"

    %w[psutil pathlib colorama six].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    output = shell_output(bin/"thefuck echho")
    assert output.include? "echo"
  end

  def caveats; <<-EOS.undent
    Add the following to your .bash_profile or .zshrc:
      bash: alias fuck='eval $(thefuck $(fc -ln -1)); history -r'
      zsh: alias fuck='eval $(thefuck $(fc -ln -1 | tail -n 1)); fc -R'

      Other shells: https://github.com/nvbn/thefuck/wiki/Shell-aliases
    EOS
  end
end
