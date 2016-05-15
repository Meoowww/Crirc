require "./spec_helper"

describe CrystalIrc do

  it "Instance without network" do
    cli = CrystalIrc::Client.new ip: "localhost", port: 6667_u16, ssl: false, nick: "CrystalBot"
    cli.should be_a(CrystalIrc::Client)
  end

  it "Test with irc.mozilla.net" do
    cli = CrystalIrc::Client.new ip: "irc.mozilla.org", port: 6667_u16, ssl: false, nick: "CrystalBotSpecS_#{rand 100..999}"
    cli.should be_a(CrystalIrc::Client)
    s = cli.connect
    s.should be_a(TCPSocket)
    s.read_timeout = 1
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
end
