describe CrystalIrc::User do
  it "Basic instanciation" do
    e = CrystalIrc::User.new "test-works"
    e.name.should eq("test-works")
    # RFC ? ahahah get out the way
    e = CrystalIrc::User.new "test_works"
    e.name.should eq("test_works")
    e = CrystalIrc::User.new "#test-works"
    e.name.should eq("#test-works")
    e = CrystalIrc::User.new("a"*50)
    e.name.should eq("a"*50)
    expect_raises(CrystalIrc::InvalidUserName) { CrystalIrc::User.new("") }
    expect_raises(CrystalIrc::InvalidUserName) { CrystalIrc::User.new("1a") }
    expect_raises(CrystalIrc::InvalidUserName) { CrystalIrc::User.new("a"*51) }
    expect_raises(CrystalIrc::InvalidUserName) { CrystalIrc::User.new("spaces in the name") }
  end

  it "Whois" do
    e = CrystalIrc::User.new("Dash", "here@1.1.1.1")
    e.name.should eq("Dash")
    e.whois.should eq("here@1.1.1.1")
    e = CrystalIrc::User.parse("Dash!here@1.1.1.1")
    e.name.should eq("Dash")
    e.whois.should eq("here@1.1.1.1")
  end
end
