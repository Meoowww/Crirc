describe CrystalIrc::Client::Nick do

  it "instanciation" do
    n = CrystalIrc::Client::Nick.new "toto"
    n.to_s.should eq("toto")
    5.times { |i| n.next; n.to_s.should eq("toto_#{i+1}") }
    expect_raises(CrystalIrc::InvalidNick) { CrystalIrc::Client::Nick.new("") }
    expect_raises(CrystalIrc::InvalidNick) { CrystalIrc::Client::Nick.new("a"*51) }
    expect_raises(CrystalIrc::InvalidNick) { CrystalIrc::Client::Nick.new("a@") }
    expect_raises(CrystalIrc::InvalidNick) { CrystalIrc::Client::Nick.new("a*") }
  end


end
