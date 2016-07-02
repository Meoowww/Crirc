describe CrystalIrc::Chan do
  it "instanciation" do
    e = CrystalIrc::Chan.new "#test_works"
    e.name.should eq("#test_works")
    e = CrystalIrc::Chan.new "##test_works"
    e.name.should eq("##test_works")
    e = CrystalIrc::Chan.new("#" + "a"*49)
    e.name.should eq("#" + "a"*49)
    expect_raises(CrystalIrc::InvalidChanName) { CrystalIrc::Chan.new("") }
    expect_raises(CrystalIrc::InvalidChanName) { CrystalIrc::Chan.new("no_#_at_begin") }
    expect_raises(CrystalIrc::InvalidChanName) { CrystalIrc::Chan.new("#" + "a"*50) }
    expect_raises(CrystalIrc::InvalidChanName) { CrystalIrc::Chan.new("#spaces in the name") }
  end
end
