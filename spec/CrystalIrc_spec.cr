require "./spec_helper"

describe CrystalIrc do

  it "Instance without network" do
    cli = CrystalIrc::Client.new ip: "localhost", port: 6667_u16, ssl: false, nick: "CrystalBot"
    cli.should be_a(CrystalIrc::Client)
  end

  it "Test with irc.mozilla.net" do
    cli = CrystalIrc::Client.new ip: "irc.mozilla.org", port: 6667_u16, ssl: false, nick: "CrystalBotSpecs"
    cli.should be_a(CrystalIrc::Client)
    s = cli.connect
    s.should be_a(TCPSocket)
    s.read_timeout = 1
    10.times {s.gets}
  end
end
