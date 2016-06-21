$verbose : Bool?

def server_process_client(s, cli)
  cli.send_raw ":0 NOTICE Auth :***You are connected***"
  begin
    loop do
      cli.gets do |str|
        STDERR.puts "server->cli.gets: #{str}" if $verbose == true
        return if str.nil?
        s.handle str, cli
      end
    end
  rescue e
    return if e.message == "Error writing file: Broken pipe"
    STDERR.puts "Error during client proccess: #{e}"
  end
end

def client_fetch(cli, str)
  STDERR.puts "fetch: #{str}" if $verbose == true
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
        cli.send_raw ":0 NOTICE Auth :***You are connected***"
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
    s.on("JOIN") do |msg|
      chan_name = msg.arguments_raw
      msg.command.should eq("JOIN")
      msg.arguments_raw.should eq("#toto") # chan_name
      # note: this message is already sent
      #msg.sender.send_raw ":0 NOTICE JOIN :#{chan_name}"
    end

    spawn { spawn server_process_client(s, s.accept) }
    cli = CrystalIrc::Client.new(nick: "nick", ip: "127.0.0.1", port: 6667_u16, ssl: false)
    cli.connect
    client_fetch cli, cli.gets
    #cli.send_login
    sleep 0.5
    cli.join([CrystalIrc::Chan.new "#toto"])
    sleep 0.5
    msg = cli.gets.to_s.chomp
    client_fetch cli, msg
    msg.should eq(":0 NOTICE user :JOINED #toto")
    s.close
  end


end
