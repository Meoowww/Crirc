describe CrystalIrc::User do
  it "Basic instanciation" do
    e = CrystalIrc::User.new "test-works"
    e.name.should eq("test-works")

    # RFC ? ahahah get out the way b***
    e = CrystalIrc::User.new "test_works"
    e.name.should eq("test_works")

    e = CrystalIrc::User.new("a"*50)
    e.name.should eq("a"*50)

    CrystalIrc::User.new("Validity").name.should eq "Validity"
    CrystalIrc::User.new("Validity|2").name.should eq "Validity|2"
    CrystalIrc::User.new("Validity-2").name.should eq "Validity-2"
    CrystalIrc::User.new("Validity_2").name.should eq "Validity_2"
    CrystalIrc::User.new("Validity[2]").name.should eq "Validity[2]"
    CrystalIrc::User.new("Validity{2}").name.should eq "Validity{2}"
    CrystalIrc::User.new("`Validity").name.should eq "`Validity" #  Not in the RFC, still accepted
  end

  it "Instanciation error" do
    expect_raises(CrystalIrc::ParsingError) { CrystalIrc::User.new("") }
    expect_raises(CrystalIrc::ParsingError) { CrystalIrc::User.new("1a") }
    expect_raises(CrystalIrc::ParsingError) { CrystalIrc::User.new("a"*51) }
    expect_raises(CrystalIrc::ParsingError) { CrystalIrc::User.new("spaces in the name") }
    expect_raises(CrystalIrc::ParsingError) { CrystalIrc::User.new("#a") }
  end

  it "Whois" do
    e = CrystalIrc::User.new("Dash", "here", "1.1.1.1")
    e.nick.should eq("Dash")
    e.id.should eq("here")
    e.whois.should eq("1.1.1.1")
    e = CrystalIrc::User.parse("Dash!here@1.1.1.1")
    e.name.should eq("Dash")
    e.id.should eq("here")
    e.whois.should eq("1.1.1.1")
  end
end
