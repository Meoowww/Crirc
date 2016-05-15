require "./spec_helper"

describe CrystalIrc do

  it "Instance without network" do
    cli = CrystalIrc::Client.new ip: "localhost", port: 6667_u16, ssl: false, nick: "CrystalBot"
    cli.should be_a(CrystalIrc::Client)
  end
end
