require "./CrystalIrc"

def server_process_client(s, cli)
  cli.send_raw ":127.0.0.1 NOTICE Auth :*** Connecting..."
  # BUG: server only accepts 1 connection?
  begin
    loop do
      cli.gets do |str|
        STDERR.puts "server->cli.gets: #{str}" if ::VERBOSE == true
        return if str.nil?
        begin
          s.handle str, cli
        rescue e
          STDERR.puts "Message error: #{e}"
        end
      end
    end
  rescue e
    STDERR.puts "Error during client proccess: #{e}. Closed"
    cli.close
  end
end

def start
  s = CrystalIrc::Server.new(host: "127.0.0.1", port: 6667_u16, ssl: false, verbose: true)
  loop do
    spawn server_process_client(s, s.accept)
  end
end

start
