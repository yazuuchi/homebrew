require 'formula'

class Sqlite < Formula
  homepage 'http://sqlite.org/'
  url 'http://www.sqlite.org/2013/sqlite-autoconf-3080200.tar.gz'
  version '3.8.2'
  sha1 '6033ef603ce221d367c665477514d972ef1dc90e'

  bottle do
    cellar :any
    sha1 '18bd82676513a70b20435a52fcc7c961a3e0ba28' => :mavericks
    sha1 '5cbafa8610ba6fe19c9bc7b31e419c18b343873b' => :mountain_lion
    sha1 'acb930e2b8358c219115b97ce3fdbba80d45dff2' => :lion
  end

  keg_only :provided_by_osx, "OS X provides an older sqlite3."

  option :universal
  option 'with-docs', 'Install HTML documentation'
  option 'without-rtree', 'Disable the R*Tree index module'
  option 'with-fts', 'Enable the FTS module'
  option 'with-functions', 'Enable more math and string functions for SQL queries'

  depends_on 'readline' => :recommended

  resource 'functions' do
    url 'http://www.sqlite.org/contrib/download/extension-functions.c?get=25', :using  => :nounzip
    version '2010-01-06'
    sha1 'c68fa706d6d9ff98608044c00212473f9c14892f'
  end

  resource 'docs' do
    url 'http://www.sqlite.org/2013/sqlite-doc-3080200.zip'
    version '3.8.2'
    sha1 'b9cbd42d08b8c1ce96656a6b111e918bb515b605'
  end

  def install
    ENV.append 'CPPFLAGS', "-DSQLITE_ENABLE_RTREE" unless build.without? "rtree"
    ENV.append 'CPPFLAGS', "-DSQLITE_ENABLE_FTS3 -DSQLITE_ENABLE_FTS3_PARENTHESIS" if build.with? "fts"

    # enable these options by default
    ENV.append 'CPPFLAGS', "-DSQLITE_ENABLE_COLUMN_METADATA"
    ENV.append 'CPPFLAGS', "-DSQLITE_ENABLE_STAT3"

    ENV.universal_binary if build.universal?

    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking", "--enable-dynamic-extensions"
    system "make install"

    if build.with? "functions"
      buildpath.install resource('functions')
      system ENV.cc, "-fno-common",
                     "-dynamiclib",
                     "extension-functions.c",
                     "-o", "libsqlitefunctions.dylib",
                     *ENV.cflags.split
      lib.install "libsqlitefunctions.dylib"
    end
    doc.install resource('docs') if build.with? "docs"
  end

  def caveats
    if build.with? 'functions' then <<-EOS.undent
      Usage instructions for applications calling the sqlite3 API functions:

        In your application, call sqlite3_enable_load_extension(db,1) to
        allow loading external libraries.  Then load the library libsqlitefunctions
        using sqlite3_load_extension; the third argument should be 0.
        See http://www.sqlite.org/cvstrac/wiki?p=LoadableExtensions.
        Select statements may now use these functions, as in
        SELECT cos(radians(inclination)) FROM satsum WHERE satnum = 25544;

      Usage instructions for the sqlite3 program:

        If the program is built so that loading extensions is permitted,
        the following will work:
         sqlite> SELECT load_extension('#{lib}/libsqlitefunctions.dylib');
         sqlite> select cos(radians(45));
         0.707106781186548
      EOS
    end
  end
end
