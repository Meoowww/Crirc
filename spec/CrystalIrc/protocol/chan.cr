describe CrystalIrc::Chan do
  it "instanciation" do
    e = CrystalIrc::Chan.new "#test_works"
    e.name.should eq("#test_works")
    e = CrystalIrc::Chan.new "##test_works"
    e.name.should eq("##test_works")
    e = CrystalIrc::Chan.new("#" + "a"*49)
    e.name.should eq("#" + "a"*49)
    expect_raises(CrystalIrc::ParsingError) { CrystalIrc::Chan.new("") }
    expect_raises(CrystalIrc::ParsingError) { CrystalIrc::Chan.new("no_#_at_begin") }
    expect_raises(CrystalIrc::ParsingError) { CrystalIrc::Chan.new("#" + "a"*50) }
    expect_raises(CrystalIrc::ParsingError) { CrystalIrc::Chan.new("#spaces in the name") }
  end

  it "user / has?" do
    c = CrystalIrc::Chan.new "#chan"
    c.users.size.should eq 0
    expect_raises(CrystalIrc::IrcError) { c.user("toto") }
    c.has?("toto").should eq false
    c.has?(CrystalIrc::User.new("toto")).should eq false

    c.users = [CrystalIrc::User.new("toto") ]
    c.user("toto").should be_a(CrystalIrc::User)
    c.has?("toto").should eq true
    c.has?(CrystalIrc::User.new("toto")).should eq true
  end
end
