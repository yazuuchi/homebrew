class Libsndfile < Formula
  desc "C library for files containing sampled sound"
  homepage "http://www.mega-nerd.com/libsndfile/"
  url "http://www.mega-nerd.com/libsndfile/files/libsndfile-1.0.25.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/libs/libsndfile/libsndfile_1.0.25.orig.tar.gz"
  sha256 "59016dbd326abe7e2366ded5c344c853829bebfd1702ef26a07ef662d6aa4882"

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "flac"
  depends_on "libogg"
  depends_on "libvorbis"

  option :universal

  # libsndfile doesn't find Carbon.h using XCode 4.3:
  # fixed upstream: https://github.com/erikd/libsndfile/commit/d04e1de82ae0af48fd09d5cb09bf21b4ca8d513c
  patch do
    url "https://gist.githubusercontent.com/metabr/8623583/raw/90966b76c6f52e1293b5303541e1f2d72e2afd08/0001-libsndfile-doesn-t-find-Carbon.h-using-XCode-4.3.patch"
    sha256 "6b5fd749ef3b4990ca011eb65289c369cff82285e99773e4a74de4615f082df5"
  end

  # libsndfile fails to build with libvorbis 1.3.4
  # fixed upstream:
  # https://github.com/erikd/libsndfile/commit/d7cc3dd0a437cfb087e09c80c0b89dfd3ec80a54
  # https://github.com/erikd/libsndfile/commit/700ae0e8f358497dd614bcee8e4b93c629209b37
  # https://github.com/erikd/libsndfile/commit/50d1df56f7f9b90d0fafc618d4947611e9689ae9
  patch do
    url "https://gist.githubusercontent.com/metabr/8623583/raw/cd3540f4abd8521edf0011ab6dd40888cfadfd7a/0002-libsndfile-fails-to-build-with-libvorbis-1.3.4.patch"
    sha256 "00697cfe8e13e6d4b36f6ad6327dd670be5a6542371b2ccabcc3175527731a41"
  end

  #
  # yaz added the genre patch for wav
  #
  patch :DATA

  def install
    ENV.universal_binary if build.universal?

    system "autoreconf", "-i"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end

__END__
--- a/programs/sndfile-metadata-get.c	2011-03-21 08:06:59.000000000 +0900
+++ b/programs/sndfile-metadata-get.c	2012-07-05 23:05:37.104941613 +0900
@@ -120,6 +120,7 @@ usage_exit (const char *progname, int ex
 		"    --str-date            Print the creation date metadata.\n"
 		"    --str-album           Print the album metadata.\n"
 		"    --str-license         Print the license metadata.\n"
+		"    --str-genre           Print the genre metadata.\n"
 		) ;
 
 	printf ("Using %s.\n\n", sf_version_string ()) ;
@@ -164,6 +165,7 @@ process_args (SNDFILE * file, const SF_B
 		HANDLE_STR_ARG ("--str-date", "Create date", SF_STR_DATE) ;
 		HANDLE_STR_ARG ("--str-album", "Album", SF_STR_ALBUM) ;
 		HANDLE_STR_ARG ("--str-license", "License", SF_STR_LICENSE) ;
+		HANDLE_STR_ARG ("--str-genre", "Genre", SF_STR_GENRE) ;
 
 		if (! do_all)
 		{	printf ("Error : Don't know what to do with command line arg '%s'.\n\n", argv [k]) ;
--- a/src/wav.c	2011-06-21 19:10:01.000000000 +0900
+++ b/src/wav.c	2012-07-05 22:44:24.739710197 +0900
@@ -1423,6 +1423,9 @@ wav_subchunk_parse (SF_PRIVATE *psf, int
 			case INAM_MARKER :
 					psf_store_string (psf, SF_STR_TITLE, psf->u.cbuf) ;
 					break ;
+			case IPRD_MARKER :
+					psf_store_string (psf, SF_STR_ALBUM, psf->u.cbuf) ;
+					break ;
 			case IART_MARKER :
 					psf_store_string (psf, SF_STR_ARTIST, psf->u.cbuf) ;
 					break ;
