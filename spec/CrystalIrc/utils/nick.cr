describe CrystalIrc::Nick do
  it "instanciation" do
    CrystalIrc::Nick.new("a").to_s.should eq("a")
    n = CrystalIrc::Nick.new "toto"
    n.to_s.should eq("toto")
    5.times { |i| n.next; n.to_s.should eq("toto_#{i + 1}") }
    expect_raises(CrystalIrc::InvalidNick) { CrystalIrc::Nick.new("") }
    expect_raises(CrystalIrc::InvalidNick) { CrystalIrc::Nick.new("a"*51) }
    expect_raises(CrystalIrc::InvalidNick) { CrystalIrc::Nick.new("a@") }
    expect_raises(CrystalIrc::InvalidNick) { CrystalIrc::Nick.new("a*") }
  end
end
