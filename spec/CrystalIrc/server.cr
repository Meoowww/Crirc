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
      s.accept { |socket| socket.puts "ok" }
    end
    TCPSocket.open("127.0.0.1", 6667) do |cli|
      got = cli.gets
      got.should eq("ok\n")
    end
  end

end
