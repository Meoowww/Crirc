describe CrystalIrc::Server do

  it "Instance" do
    CrystalIrc::Server.new(listen: "127.0.0.1", port: 6667_u16, ssl: false).should be_a(CrystalIrc::Server)
  end

end
