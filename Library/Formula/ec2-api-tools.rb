class Ec2ApiTools < AmazonWebServicesFormula
  homepage "https://aws.amazon.com/developertools/351"
  url "https://ec2-downloads.s3.amazonaws.com/ec2-api-tools-1.7.1.0.zip"
  sha1 "154acfb5d117d0af1311c65030671cd56eb987aa"

  def caveats
    standard_instructions "EC2_HOME"
  end

  test do
    ENV["JAVA_HOME"] = `/usr/libexec/java_home`.chomp
    ENV["EC2_HOME"] = libexec
    assert_match version.to_s, shell_output("#{bin}/ec2-version")
  end
end
