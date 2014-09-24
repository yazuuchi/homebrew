require 'formula'

class Libpst < Formula
  homepage 'http://www.five-ten-sg.com/libpst/'
  url 'http://www.five-ten-sg.com/libpst/packages/libpst-0.6.55.tar.gz'
  sha1 'c81df95509494c99222b0b603f7500dd9caceff1'

  bottle do
    cellar :any
    revision 1
    sha1 "397e70df07349c23ff991842e67cbdbdd5162b7c" => :mavericks
    sha1 "c5825e6dad6100636889029f79c47c506d78660c" => :mountain_lion
    sha1 "b15cf26bccfea564461e062bbceabec7bc5dedfe" => :lion
  end

  option 'pst2dii', 'Build pst2dii using gd'

  depends_on :python => :optional
  depends_on 'gd' if build.include? 'pst2dii'

  if build.with? "python"
    depends_on "boost" => "with-python"
  else
    depends_on "boost"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    args << '--disable-dii' unless build.include? 'pst2dii'
    if build.with? 'python'
      args << '--enable-python' << '--with-boost-python=mt'
    else
      args << '--disable-python'
    end
    system "./configure", *args
    system "make"
    ENV.deparallelize
    system "make", "install"
  end
end
