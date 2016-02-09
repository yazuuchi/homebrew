require "language/go"

class Kapacitor < Formula
  desc "Open source time series data processor"
  homepage "https://github.com/influxdata/kapacitor"
  url "https://github.com/influxdata/kapacitor.git",
    :tag => "v0.10.0",
    :revision => "35c9c6fe6543f9d65779d10723ea3a70657d8bba"

  head "https://github.com/influxdata/kapacitor.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2906cc0be7f6bc832ebd4df805cb4d859da5cc3e2730604dbe8bfd41e4e938d7" => :el_capitan
    sha256 "20d0f8ca06186bfade9763ed76c90e80a5a6fb19a8dbce5beb300bd2c65f38eb" => :yosemite
    sha256 "7564e43eb0852049a1ec0c1557622592ccf345bbdac9e8ae3c09fe288eeb37c2" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/BurntSushi/toml" do
    url "https://github.com/BurntSushi/toml.git",
    :revision => "5c4df71dfe9ac89ef6287afc05e4c1b16ae65a1e"
  end

  go_resource "github.com/armon/go-metrics" do
    url "https://github.com/armon/go-metrics.git",
    :revision => "345426c77237ece5dab0e1605c3e4b35c3f54757"
  end

  go_resource "github.com/boltdb/bolt" do
    url "https://github.com/boltdb/bolt.git",
    :revision => "ee4a0888a9abe7eefe5a0992ca4cb06864839873"
  end

  go_resource "github.com/dustin/go-humanize" do
    url "https://github.com/dustin/go-humanize.git",
    :revision => "8929fe90cee4b2cb9deb468b51fb34eba64d1bf0"
  end

  go_resource "github.com/gogo/protobuf" do
    url "https://github.com/gogo/protobuf.git",
    :revision => "82d16f734d6d871204a3feb1a73cb220cc92574c"
  end

  go_resource "github.com/gorhill/cronexpr" do
    url "https://github.com/gorhill/cronexpr.git",
    :revision => "a557574d6c024ed6e36acc8b610f5f211c91568a"
  end

  go_resource "github.com/hashicorp/go-msgpack" do
    url "https://github.com/hashicorp/go-msgpack.git",
    :revision => "fa3f63826f7c23912c15263591e65d54d080b458"
  end

  go_resource "github.com/hashicorp/raft" do
    url "https://github.com/hashicorp/raft.git",
    :revision => "057b893fd996696719e98b6c44649ea14968c811"
  end

  go_resource "github.com/hashicorp/raft-boltdb" do
    url "https://github.com/hashicorp/raft-boltdb.git",
    :revision => "d1e82c1ec3f15ee991f7cc7ffd5b67ff6f5bbaee"
  end

  go_resource "github.com/influxdb/influxdb" do
    url "https://github.com/influxdb/influxdb.git",
    :revision => "28ae8b6fe06705999a444d47c0766cc47b007643"
  end

  go_resource "github.com/influxdb/usage-client" do
    url "https://github.com/influxdb/usage-client.git",
    :revision => "475977e68d79883d9c8d67131c84e4241523f452"
  end

  go_resource "github.com/kimor79/gollectd" do
    url "https://github.com/kimor79/gollectd.git",
    :revision => "61d0deeb4ffcc167b2a1baa8efd72365692811bc"
  end

  go_resource "github.com/mattn/go-runewidth" do
    url "https://github.com/mattn/go-runewidth.git",
    :revision => "e882a96ec18dd43fa283187b66af74497c9101c0"
  end

  go_resource "github.com/russross/blackfriday" do
    url "https://github.com/russross/blackfriday.git",
    :revision => "006144af03eeeff1037240a71865a9fd61f1c25f"
  end

  go_resource "github.com/serenize/snaker" do
    url "https://github.com/serenize/snaker.git",
    :revision => "d88cc11617e4f179fa2c821a60908d5fabd7bdad"
  end

  go_resource "github.com/shurcooL/go" do
    url "https://github.com/shurcooL/go.git",
    :revision => "4d829e4f99c3765122ba92c78b8f69cc0392983d"
  end

  go_resource "github.com/shurcooL/markdownfmt" do
    url "https://github.com/shurcooL/markdownfmt.git",
    :revision => "b191517d76ef6b1ac2599ea819579d6256fb160e"
  end

  go_resource "github.com/shurcooL/sanitized_anchor_name" do
    url "https://github.com/shurcooL/sanitized_anchor_name.git",
    :revision => "10ef21a441db47d8b13ebcc5fd2310f636973c77"
  end

  go_resource "github.com/stretchr/testify" do
    url "https://github.com/stretchr/testify.git",
    :revision => "a1f97990ddc16022ec7610326dd9bce31332c116"
  end

  go_resource "github.com/twinj/uuid" do
    url "https://github.com/twinj/uuid.git",
    :revision => "89173bcdda19db0eb88aef1e1cb1cb2505561d31"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
    :revision => "1f22c0103821b9390939b6776727195525381532"
  end

  go_resource "gopkg.in/fatih/pool.v2" do
    url "https://gopkg.in/fatih/pool.v2.git",
    :revision => "cba550ebf9bce999a02e963296d4bc7a486cb715"
  end

  go_resource "gopkg.in/gomail.v2" do
    url "https://gopkg.in/gomail.v2.git",
    :revision => "fbb71ddc63acd07dd0ed49ababdf02c551e2539a"
  end

  def install
    ENV["GOPATH"] = buildpath
    kapacitor_path = buildpath/"src/github.com/influxdata/kapacitor"
    kapacitor_path.install Dir["*"]
    revision = `git rev-parse HEAD`

    Language::Go.stage_deps resources, buildpath/"src"

    cd kapacitor_path do
      system "go", "install",
             "-ldflags", "-X main.version=#{version} -X main.commit=#{revision}",
             "./..."
    end

    inreplace kapacitor_path/"etc/kapacitor/kapacitor.conf" do |s|
      s.gsub! "/var/lib/kapacitor", "#{var}/kapacitor"
      s.gsub! "/var/log/kapacitor", "#{var}/log"
    end

    bin.install "bin/kapacitord"
    bin.install "bin/kapacitor"
    etc.install kapacitor_path/"etc/kapacitor/kapacitor.conf" => "kapacitor.conf"

    (var/"kapacitor/replay").mkpath
    (var/"kapacitor/tasks").mkpath
  end

  plist_options :manual => "kapacitord -config #{HOMEBREW_PREFIX}/etc/kapacitor.conf"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <dict>
          <key>SuccessfulExit</key>
          <false/>
        </dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/kapacitord</string>
          <string>-config</string>
          <string>#{HOMEBREW_PREFIX}/etc/kapacitor.conf</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/kapacitor.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/kapacitor.log</string>
      </dict>
    </plist>
    EOS
  end

  test do
    logo = <<-EOS.undent
      '##:::'##::::'###::::'########:::::'###:::::'######::'####:'########::'#######::'########::
       ##::'##::::'## ##::: ##.... ##:::'## ##:::'##... ##:. ##::... ##..::'##.... ##: ##.... ##:
       ##:'##::::'##:. ##:: ##:::: ##::'##:. ##:: ##:::..::: ##::::: ##:::: ##:::: ##: ##:::: ##:
       #####::::'##:::. ##: ########::'##:::. ##: ##:::::::: ##::::: ##:::: ##:::: ##: ########::
       ##. ##::: #########: ##.....::: #########: ##:::::::: ##::::: ##:::: ##:::: ##: ##.. ##:::
       ##:. ##:: ##.... ##: ##:::::::: ##.... ##: ##::: ##:: ##::::: ##:::: ##:::: ##: ##::. ##::
       ##::. ##: ##:::: ##: ##:::::::: ##:::: ##:. ######::'####:::: ##::::. #######:: ##:::. ##:
      ..::::..::..:::::..::..:::::::::..:::::..:::......:::....:::::..::::::.......:::..:::::..::
    EOS
    (testpath/"config.toml").write shell_output("kapacitord config")
    assert_match /#{logo}/m, shell_output("kapacitord -config #{testpath}/config.toml", 1)
  end
end
