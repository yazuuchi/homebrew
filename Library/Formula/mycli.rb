class Mycli < Formula
  desc "CLI for MySQL with auto-completion and syntax highlighting"
  homepage "http://mycli.net/"
  url "https://pypi.python.org/packages/source/m/mycli/mycli-1.0.1.tar.gz"
  sha256 "9ef67c40b32410c7dbc1bca9058b542b5b2ccc33a3826c419fcd33b46a21f5f4"

  bottle do
    cellar :any
    sha256 "7a72fd4437716e7f7b304ee431cfa9885930264b60eba10d4a4f44b7c8bd376a" => :yosemite
    sha256 "ab9c042057116597d5cecc3c44ceff50d1a335c82223092c592483c4a968ed4c" => :mavericks
    sha256 "23a3afd595ac93b9c17987a9d6e0a509b1ef3ad8db43fb9def7266b72902d441" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "openssl"

  resource "click" do
    url "https://pypi.python.org/packages/source/c/click/click-4.1.tar.gz"
    sha256 "e339ed09f25e2145314c902a870bc959adcb25653a2bd5cc1b48d9f56edf8ed8"
  end

  resource "configobj" do
    url "https://pypi.python.org/packages/source/c/configobj/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "prompt_toolkit" do
    url "https://pypi.python.org/packages/source/p/prompt_toolkit/prompt_toolkit-0.38.tar.gz"
    sha256 "6cee2959747580a1f93e3e14ef2826f1d89845d19e5bc32f374c23988e2d5e66"
  end

  resource "Pygments" do
    url "https://pypi.python.org/packages/source/P/Pygments/Pygments-2.0.2.tar.gz"
    sha256 "7320919084e6dac8f4540638a46447a3bd730fca172afc17d2c03eed22cf4f51"
  end

  resource "PyMySQL" do
    url "https://pypi.python.org/packages/source/P/PyMySQL/PyMySQL-0.6.6.tar.gz"
    sha256 "c18e62ca481c5ada6c7bee1b81fc003d6ceae932c878db384cd36808010b3774"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha256 "e24052411fc4fbd1f672635537c3fc2330d9481b18c0317695b46259512c91d5"
  end

  resource "sqlparse" do
    url "https://pypi.python.org/packages/source/s/sqlparse/sqlparse-0.1.14.tar.gz"
    sha256 "e561e31853ab9f3634a1a2bd53035f9e47dfb203d56b33cc6569047ba087daf0"
  end

  resource "wcwidth" do
    url "https://pypi.python.org/packages/source/w/wcwidth/wcwidth-0.1.4.tar.gz"
    sha256 "906d3123045d77027b49fe912458e1a1e1d6ca1a51558a4bd9168d143b129d2b"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[click prompt_toolkit PyMySQL sqlparse Pygments wcwidth six configobj].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system bin/"mycli", "--help"
  end
end
