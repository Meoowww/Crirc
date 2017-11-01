describe Crirc::Protocol::Chan do
  it "instanciation" do
    e = Crirc::Protocol::Chan.new "#test_works"
    e.name.should eq("#test_works")
    e = Crirc::Protocol::Chan.new "##test_works"
    e.name.should eq("##test_works")
    e = Crirc::Protocol::Chan.new("#" + "a"*49)
    e.name.should eq("#" + "a"*49)
    expect_raises(Crirc::Protocol::Chan::ParsingError) { Crirc::Protocol::Chan.new("") }
    expect_raises(Crirc::Protocol::Chan::ParsingError) { Crirc::Protocol::Chan.new("no_#_at_begin") }
    expect_raises(Crirc::Protocol::Chan::ParsingError) { Crirc::Protocol::Chan.new("#" + "a"*50) }
    expect_raises(Crirc::Protocol::Chan::ParsingError) { Crirc::Protocol::Chan.new("#spaces in the name") }
  end
end
