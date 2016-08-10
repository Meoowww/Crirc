describe CrystalIrc::Client do
  it "Instance without network" do
    CrystalIrc::Client.new(ip: "localhost", port: 6667_u16, ssl: false, nick: "CrystalBot").should be_a(CrystalIrc::Client)
    CrystalIrc::Client.new(ip: "localhost", nick: "CrystalBot").should be_a(CrystalIrc::Client)
  end

  it "chans / chan / has?" do
    cli = CrystalIrc::Client.new("nick", "localhost")
    cli.chans.size.should eq 0
    expect_raises(CrystalIrc::IrcError) { cli.chan("#chan1") }
    cli.has?("#chan1").should eq false
    cli.has?(CrystalIrc::Chan.new("#chan1")).should eq false

    cli.chans << CrystalIrc::Chan.new("#chan1")
    cli.chans.size.should eq 1
    cli.chans << CrystalIrc::Chan.new("#chan2")
    cli.chans.size.should eq 2

    cli.chan("#chan1").should be_a(CrystalIrc::Chan)
    cli.has?("#chan1").should eq true
    cli.has?(CrystalIrc::Chan.new("#chan1")).should eq true
  end
end
