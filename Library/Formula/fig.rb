class Fig < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/1.3.3.tar.gz"
  sha256 "9cf4f02f897ff2f0df6e46e3d46f9f91271856cc52680928d916b0d4c969218f"

  bottle do
    sha256 "14e1779bcc1233d4b2c8ccebc623661d3da6758b14dac4aed270a9cad16b442b" => :yosemite
    sha256 "57cd1ae0e19bdb446d003e15790f966033a76d2865fff4d2375302a8c9ac60c9" => :mavericks
    sha256 "a3107b7b90525892364e6c5d99d491738c34605c5cf495a322c9e3ce70c38cab" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "libyaml"

  # It's possible that the user wants to manually install Docker and Boot2Docker,
  # for example, they want to compile Docker manually
  depends_on "docker" => :recommended
  depends_on "boot2docker" => :recommended

  resource "docker-py" do
    url "https://pypi.python.org/packages/source/d/docker-py/docker-py-1.3.0.tar.gz"
    sha256 "ac4c960e84a44f5dbbcee775c46c3a8a194241e37767f60d64aa84d704c95dfd"
  end

  resource "pyyaml" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.11.tar.gz"
    sha256 "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha256 "e24052411fc4fbd1f672635537c3fc2330d9481b18c0317695b46259512c91d5"
  end

  resource "dockerpty" do
    url "https://pypi.python.org/packages/source/d/dockerpty/dockerpty-0.3.4.tar.gz"
    sha256 "a51044cc49089a2408fdf6769a63eebe0b16d91f34716ecee681984446ce467d"
  end

  resource "texttable" do
    url "https://pypi.python.org/packages/source/t/texttable/texttable-0.8.3.tar.gz"
    sha256 "f333ac915e7c5daddc7d4877b096beafe74ea88b4b746f82a4b110f84e348701"
  end

  resource "docopt" do
    url "https://pypi.python.org/packages/source/d/docopt/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.6.1.tar.gz"
    sha256 "490b111c824d64b84797a899a4c22618bbc45323ac24a0a0bb4b73a8758e943c"
  end

  resource "websocket-client" do
    url "https://github.com/liris/websocket-client/archive/v0.32.0.tar.gz"
    sha256 "255d07ffa677f571b5f51c11703f2f4bd5f331b58442677bcb4395dfa1809a5f"
  end

  resource "backports.ssl_match_hostname" do
    url "https://pypi.python.org/packages/source/b/backports.ssl_match_hostname/backports.ssl_match_hostname-3.4.0.2.tar.gz"
    sha256 "07410e7fb09aab7bdaf5e618de66c3dac84e2e3d628352814dc4c37de321d6ae"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bash_completion.install "contrib/completion/bash/docker-compose"

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
    ln_s bin/"docker-compose", bin/"fig"
  end

  test do
    assert_match /#{version}/, shell_output(bin/"docker-compose --version")
  end
end
