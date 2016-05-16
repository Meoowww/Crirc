describe CrystalIrc::CircularBuffer do

  it "Circular buffer bases" do
    b = CrystalIrc::CircularBuffer.new
    b << "a" << "b" << "c"
    b[0].should eq("a")
    b[1].should eq("b")
    b[2].should eq("c")
    b.next.should eq("a")
    b.next.should eq("b")
    b.next.should eq("c")
    b.next.should eq("a")
  end

end
