describe CrystalIrc::Server::Client do
  it "Instance" do
    s = CrystalIrc::Server.new(host: "127.0.0.1", port: 6667_u16, ssl: false)
    c = CrystalIrc::Server::Client.new(TCPSocket.new("127.0.0.1", 6667))
    c.should be_a(CrystalIrc::Server::Client)
    s.accept { }
  end
end
