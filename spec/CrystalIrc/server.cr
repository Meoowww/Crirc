def process_client(s, cli)
  cli.puts ":0 NOTICE Auth :***You are connected***"
  loop do
    begin
      s.handle cli.gets.to_s, cli
    rescue e
      puts e
    end
  end
end

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
        cli.puts ":0 NOTICE Auth :***You are connected***"
      end
    end
    TCPSocket.open("127.0.0.1", 6667) do |socket|
      got = socket.gets
      got.should eq(":0 NOTICE Auth :***You are connected***\n")
    end
    s.close
  end

  it "Server binding" do
    s = CrystalIrc::Server.new(host: "127.0.0.1", port: 6667_u16, ssl: false)
    s.on("JOIN") do |_, msg|
      chan_name = msg.message.to_s.split(" ").first
      msg.command.should eq("JOIN")
      msg.arguments_raw.should eq("#toto")
      msg.sender.puts ":0 NOTICE JOIN :#{chan_name}"
    end

    spawn do
      spawn process_client(s, s.accept)
    end
    cli = CrystalIrc::Client.new(nick: "nick", ip: "127.0.0.1", port: 6667_u16, ssl: false)
    cli.connect
    cli.join([CrystalIrc::Chan.new "#toto"])
    sleep 0.5
    s.close
  end


end
