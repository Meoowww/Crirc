describe CrystalIrc::Server do
  it "Instance" do
    s = CrystalIrc::Server.new(host: "127.0.0.1", port: 6667_u16, ssl: false)
    s.should be_a(CrystalIrc::Server)
    s.close
    CrystalIrc::Server.open(host: "127.0.0.1", port: 6667_u16, ssl: false) do |s|
      s.should be_a(CrystalIrc::Server)
    end
  end

  it "Listen" do
    s = CrystalIrc::Server.new(host: "127.0.0.1", port: 6667_u16, ssl: false)
    spawn do
      s.accept do |cli|
        cli.should be_a(CrystalIrc::Server::Client)
        cli.send_raw ":0 NOTICE Auth :***You are connected***"
      end
    end
    TCPSocket.open("127.0.0.1", 6667) do |socket|
      got = socket.gets
      got.should eq(":0 NOTICE Auth :***You are connected***")
    end
    s.close
  end
end
