require 'formula'

class Go < Formula
  homepage 'http://golang.org'
  head 'https://go.googlecode.com/hg/'
  url 'https://storage.googleapis.com/golang/go1.3.1.src.tar.gz'
  version '1.3.1'
  sha1 'bc296c9c305bacfbd7bff9e1b54f6f66ae421e6e'

  bottle do
    revision 1
    sha1 "9637d93efc0f70b1bdf3412f6684247a46104105" => :mavericks
    sha1 "fbb03d1111c201253abf12ec8440761b0d6833f7" => :mountain_lion
    sha1 "398053db3dc27be9797bd4cdd583b57a12033483" => :lion
  end

  option 'cross-compile-all', "Build the cross-compilers and runtime support for all supported platforms"
  option 'cross-compile-common', "Build the cross-compilers and runtime support for darwin, linux and windows"
  option 'without-cgo', "Build without cgo"

  def install
    # install the completion scripts
    bash_completion.install 'misc/bash/go' => 'go-completion.bash'
    zsh_completion.install 'misc/zsh/go' => '_go'

    # host platform (darwin) must come last in the targets list
    if build.include? 'cross-compile-all'
      targets = [
        ['linux',   ['386', 'amd64', 'arm']],
        ['freebsd', ['386', 'amd64', 'arm']],
        ['netbsd',  ['386', 'amd64', 'arm']],
        ['openbsd', ['386', 'amd64']],
        ['windows', ['386', 'amd64']],
        ['dragonfly', ['386', 'amd64']],
        ['plan9',   ['386', 'amd64']],
        ['solaris', ['amd64']],
        ['darwin',  ['386', 'amd64']],
      ]
    elsif build.include? 'cross-compile-common'
      targets = [
        ['linux',   ['386', 'amd64', 'arm']],
        ['windows', ['386', 'amd64']],
        ['darwin',  ['386', 'amd64']],
      ]
    else
      targets = [['darwin', ['']]]
    end

    # The version check is due to:
    # http://codereview.appspot.com/5654068
    (buildpath/'VERSION').write('default') if build.head?

    cd 'src' do
      targets.each do |os, archs|
        cgo_enabled = os == 'darwin' && build.with?('cgo') ? "1" : "0"
        archs.each do |arch|
          ENV['GOROOT_FINAL'] = libexec
          ENV['GOOS']         = os
          ENV['GOARCH']       = arch
          ENV['CGO_ENABLED']  = cgo_enabled
          system "./make.bash", "--no-clean"
        end
      end
    end

    (buildpath/'pkg/obj').rmtree

    libexec.install Dir['*']
    bin.install_symlink Dir["#{libexec}/bin/go*"]
  end

  def caveats; <<-EOS.undent
    As of go 1.2, a valid GOPATH is required to use the `go get` command:
      http://golang.org/doc/code.html#GOPATH

    `go vet` and `go doc` are now part of the go.tools sub repo:
      http://golang.org/doc/go1.2#go_tools_godoc

    To get `go vet` and `go doc` run:
      go get code.google.com/p/go.tools/cmd/godoc
      go get code.google.com/p/go.tools/cmd/vet

    You may wish to add the GOROOT-based install location to your PATH:
      export PATH=$PATH:#{opt_libexec}/bin
    EOS
  end

  test do
    (testpath/'hello.go').write <<-EOS.undent
    package main

    import "fmt"

    func main() {
        fmt.Println("Hello World")
    }
    EOS
    # Run go fmt check for no errors then run the program.
    # This is a a bare minimum of go working as it uses fmt, build, and run.
    system "#{bin}/go", "fmt", "hello.go"
    assert_equal "Hello World\n", `#{bin}/go run hello.go`
  end
end
