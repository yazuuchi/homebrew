require 'formula'

class Navi2ch <Formula
  url 'http://downloads.sourceforge.net/project/navi2ch/navi2ch/navi2ch-1.8.4/navi2ch-1.8.4.tar.gz'
  head 'git://navi2ch.git.sourceforge.net/gitroot/navi2ch/navi2ch'
  homepage 'http://navi2ch.sourceforge.net/'
  sha256 'a2647881d1c20539148f8a01fcfa6f230d59582331ffd2d930effcbba307c603'

  def install
    system "./configure",
           "EMACS=#{HOMEBREW_PREFIX}/bin/emacs", # use emacs which installed by homebrew
           "--with-lispdir=#{HOMEBREW_PREFIX}/share/emacs/site-lisp/navi2ch",
           "--infodir=#{HOMEBREW_PREFIX}/share/info"
    system "make"
    system "make install"
  end
end
