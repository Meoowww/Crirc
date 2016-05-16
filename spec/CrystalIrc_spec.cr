require "./spec_helper"
require "./CrystalIrc/*"

def test_cli(cli : CrystalIrc::Client)
  s = cli.connect
  s.should be_a(CrystalIrc::Client::IrcSocket)
  spawn do
    begin
      loop { puts s.gets }
    rescue
      puts "end"
    end
  end
  sleep 1
  chan = CrystalIrc::Chan.new("#nyupatate")
  cli.join([chan])
  cli.privmsg(target: chan, msg: "I'm a dwarf and I'm digging a hole. Diggy diggy hole.")
  sleep 1
end

describe CrystalIrc do

  it "Nick behavior" do
    n = CrystalIrc::Client::Nick.new "toto"
    n.to_s.should eq("toto")
    5.times { |i| n.next; n.to_s.should eq("toto_#{i+1}") }
  end

  it "Instance without network" do
    cli = CrystalIrc::Client.new ip: "localhost", port: 6667_u16, ssl: false, nick: "CrystalBot"
    cli.should be_a(CrystalIrc::Client)
  end

  it "Test with irc.mozilla.net" do
    ENV.fetch("OFFLINE") { |e, v|
      next if v == "true"
      cli = CrystalIrc::Client.new ip: "irc.mozilla.org", port: 6667_u16, ssl: false, nick: "CrystalBotSpecS_#{rand 100..999}"
      cli.should be_a(CrystalIrc::Client)
      test_cli(cli)
    }
  end

  it "Test with irc.mozilla.net with ssl" do
    ENV.fetch("OFFLINE") { |e, v|
      next if v == "true"
      cli = CrystalIrc::Client.new ip: "irc.mozilla.org", port: 6697_u16, ssl: true, nick: "CrystalBotSpecS_#{rand 100..999}"
      cli.should be_a(CrystalIrc::Client)
      test_cli(cli)
    }
  end

end
