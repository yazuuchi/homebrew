require 'formula'
 
class Dblatex < Formula
  env :userpaths
  url 'http://downloads.sourceforge.net/project/dblatex/dblatex/dblatex-0.3.4/dblatex-0.3.4.tar.bz2'
  homepage 'http://dblatex.sourceforge.net'
  md5 'a511a2eaa55757b341e4c46353c5c681'
 
  def install
    system "python", "setup.py", "install", "--prefix=#{prefix}", "--install-scripts=#{bin}"
  end
 
  def patches
    #Fixes attr error install_layout
    DATA
  end
end
 
__END__
diff --git a/setup.py b/setup.py
index 2fa793f..a842cc0 100644
--- a/setup.py
+++ b/setup.py
@@ -365,10 +365,7 @@ class Install(install):
             raise OSError("not found: %s" % ", ".join(mis_stys))
 
     def run(self):
-        if self.install_layout == "deb":
-            db = DebianInstaller(self)
-        else:
-            db = None
+        db = None
 
         if not(db) and not(self.nodeps):
             try: