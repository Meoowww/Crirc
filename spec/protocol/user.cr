describe Crirc::Protocol::User do
  it "Basic instanciation" do
    e = Crirc::Protocol::User.new "test-works"
    e.name.should eq("test-works")

    # RFC ? ahahah get out the way b***
    e = Crirc::Protocol::User.new "test_works"
    e.name.should eq("test_works")

    e = Crirc::Protocol::User.new("a"*50)
    e.name.should eq("a"*50)

    Crirc::Protocol::User.new("Validity").name.should eq "Validity"
    Crirc::Protocol::User.new("Validity|2").name.should eq "Validity|2"
    Crirc::Protocol::User.new("Validity-2").name.should eq "Validity-2"
    Crirc::Protocol::User.new("Validity_2").name.should eq "Validity_2"
    Crirc::Protocol::User.new("Validity[2]").name.should eq "Validity[2]"
    Crirc::Protocol::User.new("Validity{2}").name.should eq "Validity{2}"
    Crirc::Protocol::User.new("`Validity").name.should eq "`Validity" #  Not in the RFC, still accepted
  end

  it "Instanciation error" do
    expect_raises(Crirc::Protocol::User::ParsingError) { Crirc::Protocol::User.new("") }
    expect_raises(Crirc::Protocol::User::ParsingError) { Crirc::Protocol::User.new("1a") }
    expect_raises(Crirc::Protocol::User::ParsingError) { Crirc::Protocol::User.new("a"*51) }
    expect_raises(Crirc::Protocol::User::ParsingError) { Crirc::Protocol::User.new("spaces in the name") }
    expect_raises(Crirc::Protocol::User::ParsingError) { Crirc::Protocol::User.new("#a") }
  end

  it "Whois" do
    e = Crirc::Protocol::User.new("Dash", "here", "1.1.1.1")
    e.nick.should eq("Dash")
    e.id.should eq("here")
    e.whois.should eq("1.1.1.1")
    e = Crirc::Protocol::User.parse("Dash!here@1.1.1.1")
    e.name.should eq("Dash")
    e.id.should eq("here")
    e.whois.should eq("1.1.1.1")
  end
end
