describe CrystalIrc::User do

  it "instanciation" do
    e = CrystalIrc::User.new "test-works"
    e.name.should eq("test-works")
    e = CrystalIrc::User.new "#test-works"
    e.name.should eq("#test-works")
    e = CrystalIrc::User.new("a"*50)
    e.name.should eq("a"*50)
    expect_raises(CrystalIrc::InvalidUserName) { CrystalIrc::User.new("") }
    expect_raises(CrystalIrc::InvalidUserName) { CrystalIrc::User.new("1a") }
    expect_raises(CrystalIrc::InvalidUserName) { CrystalIrc::User.new("a"*51) }
    expect_raises(CrystalIrc::InvalidUserName) { CrystalIrc::User.new("spaces in the name") }
    expect_raises(CrystalIrc::InvalidUserName) { CrystalIrc::User.new("underscores_in_the_name") }
  end


end
