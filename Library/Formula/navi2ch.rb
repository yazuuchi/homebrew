require 'formula'

class Navi2ch <Formula
  url 'http://downloads.sourceforge.net/project/navi2ch/navi2ch/navi2ch-1.8.4/navi2ch-1.8.4.tar.gz'
  head 'git://navi2ch.git.sourceforge.net/gitroot/navi2ch/navi2ch'
  homepage 'http://navi2ch.sourceforge.net/'
  md5 'af72b1c72ea9e10aafb0744b17ffe79a'

  def install
    system "./configure",
           "EMACS=#{HOMEBREW_PREFIX}/bin/emacs", # use emacs which installed by homebrew
           "--with-lispdir=#{HOMEBREW_PREFIX}/share/emacs/site-lisp/navi2ch",
           "--infodir=#{HOMEBREW_PREFIX}/share/info"
    system "make"
    system "make install"
  end
end
