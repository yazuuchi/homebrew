require 'formula'

class Git < Formula
  homepage "http://git-scm.com"
  url "https://www.kernel.org/pub/software/scm/git/git-2.0.2.tar.gz"
  sha1 "794cba6b2ba2620a08651b9605bac0476804d67e"

  head "https://github.com/git/git.git", :shallow => false

  bottle do
    sha1 "a61246dedf1cda65d7f46a0510a0002e6150c529" => :mavericks
    sha1 "07446cff2bb66eb3213ade6effb9828c01ff09b1" => :mountain_lion
    sha1 "494920224ff82d73155d875e742f39f0c3be3a8f" => :lion
  end

  resource "man" do
    url "https://www.kernel.org/pub/software/scm/git/git-manpages-2.0.2.tar.gz"
    sha1 "d4967cbe1940b7d1e131b8f0c2f609a49c569014"
  end

  resource "html" do
    url "https://www.kernel.org/pub/software/scm/git/git-htmldocs-2.0.2.tar.gz"
    sha1 "156b6ca6b626cbb6f38cbd4810c6ae69c9a4c6d5"
  end

  option 'with-blk-sha1', 'Compile with the block-optimized SHA1 implementation'
  option 'without-completions', 'Disable bash/zsh completions from "contrib" directory'
  option 'with-brewed-openssl', "Build with Homebrew OpenSSL instead of the system version"
  option 'with-brewed-curl', "Use Homebrew's version of cURL library"
  option 'with-brewed-svn', "Use Homebrew's version of SVN"
  option 'with-persistent-https', 'Build git-remote-persistent-https from "contrib" directory'

  depends_on 'pcre' => :optional
  depends_on 'gettext' => :optional
  depends_on 'openssl' if build.with? 'brewed-openssl'
  depends_on 'curl' if build.with? 'brewed-curl'
  depends_on 'go' => :build if build.with? 'persistent-https'
  depends_on 'subversion' => 'perl' if build.with? 'brewed-svn'

  def install
    # If these things are installed, tell Git build system to not use them
    ENV['NO_FINK'] = '1'
    ENV['NO_DARWIN_PORTS'] = '1'
    ENV['V'] = '1' # build verbosely
    ENV['NO_R_TO_GCC_LINKER'] = '1' # pass arguments to LD correctly
    ENV['PYTHON_PATH'] = which 'python'
    ENV['PERL_PATH'] = which 'perl'

    if build.with? 'brewed-svn'
      ENV["PERLLIB_EXTRA"] = "#{Formula["subversion"].prefix}/Library/Perl/5.16/darwin-thread-multi-2level"
    elsif MacOS.version >= :mavericks
      ENV["PERLLIB_EXTRA"] = %W{
        #{MacOS.active_developer_dir}
        /Library/Developer/CommandLineTools
        /Applications/Xcode.app/Contents/Developer
      }.uniq.map { |p|
        "#{p}/Library/Perl/5.16/darwin-thread-multi-2level"
      }.join(":")
    end

    unless quiet_system ENV['PERL_PATH'], '-e', 'use ExtUtils::MakeMaker'
      ENV['NO_PERL_MAKEMAKER'] = '1'
    end

    ENV['BLK_SHA1'] = '1' if build.with? 'blk-sha1'

    if build.with? 'pcre'
      ENV['USE_LIBPCRE'] = '1'
      ENV['LIBPCREDIR'] = Formula['pcre'].opt_prefix
    end

    ENV['NO_GETTEXT'] = '1' if build.without? 'gettext'

    ENV['GIT_DIR'] = cached_download/".git" if build.head?

    system "make", "prefix=#{prefix}",
                   "sysconfdir=#{etc}",
                   "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "LDFLAGS=#{ENV.ldflags}",
                   "install"

    bin.install Dir["contrib/remote-helpers/git-remote-{hg,bzr}"]

    # Install the OS X keychain credential helper
    cd 'contrib/credential/osxkeychain' do
      system "make", "CC=#{ENV.cc}",
                     "CFLAGS=#{ENV.cflags}",
                     "LDFLAGS=#{ENV.ldflags}"
      bin.install 'git-credential-osxkeychain'
      system "make", "clean"
    end

    # Install git-subtree
    cd 'contrib/subtree' do
      system "make", "CC=#{ENV.cc}",
                     "CFLAGS=#{ENV.cflags}",
                     "LDFLAGS=#{ENV.ldflags}"
      bin.install 'git-subtree'
    end

    if build.with? 'persistent-https'
      cd 'contrib/persistent-https' do
        system "make"
        bin.install 'git-remote-persistent-http',
                    'git-remote-persistent-https',
                    'git-remote-persistent-https--proxy'
      end
    end

    if build.with? 'completions'
      # install the completion script first because it is inside 'contrib'
      bash_completion.install 'contrib/completion/git-completion.bash'
      bash_completion.install 'contrib/completion/git-prompt.sh'

      zsh_completion.install 'contrib/completion/git-completion.zsh' => '_git'
      cp "#{bash_completion}/git-completion.bash", zsh_completion
    end

    (share+'git-core').install 'contrib'

    # We could build the manpages ourselves, but the build process depends
    # on many other packages, and is somewhat crazy, this way is easier.
    man.install resource('man')
    (share+'doc/git-doc').install resource('html')

    # Make html docs world-readable
    chmod 0644, Dir["#{share}/doc/git-doc/**/*.{html,txt}"]
    chmod 0755, Dir["#{share}/doc/git-doc/{RelNotes,howto,technical}"]
  end

  def caveats; <<-EOS.undent
    The OS X keychain credential helper has been installed to:
      #{HOMEBREW_PREFIX}/bin/git-credential-osxkeychain

    The 'contrib' directory has been installed to:
      #{HOMEBREW_PREFIX}/share/git-core/contrib
    EOS
  end

  test do
    HOMEBREW_REPOSITORY.cd do
      assert_equal 'bin/brew', `#{bin}/git ls-files -- bin`.strip
    end
  end
end
