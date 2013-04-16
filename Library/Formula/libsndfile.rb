require 'formula'

class Libsndfile < Formula
  homepage 'http://www.mega-nerd.com/libsndfile/'
  url 'http://www.mega-nerd.com/libsndfile/files/libsndfile-1.0.25.tar.gz'
  sha1 'e95d9fca57f7ddace9f197071cbcfb92fa16748e'

  depends_on 'pkg-config' => :build

  option :universal

  def patches
    # libsndfile doesn't find Carbon.h using XCode 4.3:
    # fixed upstream: https://github.com/erikd/libsndfile/commit/d04e1de82ae0af48fd09d5cb09bf21b4ca8d513c
    #
    # yaz added the genre patch for wav
    #
    DATA
  end

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
--- a/programs/sndfile-play.c	2011-03-27 22:15:31.000000000 -0700
+++ b/programs/sndfile-play.c	2012-02-24 20:02:06.000000000 -0800
@@ -58,7 +58,6 @@
 	#include 	<sys/soundcard.h>
 
 #elif (defined (__MACH__) && defined (__APPLE__))
-	#include <Carbon.h>
 	#include <CoreAudio/AudioHardware.h>
 
 #elif defined (HAVE_SNDIO_H)
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
