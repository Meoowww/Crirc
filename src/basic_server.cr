require "./CrystalIrc"

def server_process_client(s, cli)
  cli.send_raw ":0 NOTICE Auth :***You are connected***"
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
  s.on("WHOIS") do |msg|
    msg.sender.answer_raw "311 #{msg.raw_arguments.to_s} #{msg.raw_arguments.to_s} ~#{msg.raw_arguments.to_s} 0 * ok@ok"
  end.on("NICK") do |msg|
    msg.sender.answer_raw "NICK :#{msg.raw_arguments.to_s}"
  end.on("USER") do |msg|
    msg.sender.answer_raw "462 #{msg.raw_arguments.to_s} : nop"
  end.on("JOIN") do |msg|
    chans = msg.raw_arguments.to_s.split(",").map { |e| CrystalIrc::Chan.new e.strip }
    # TODO: create the chan if needed
    # TODO: add the user the the chans
    # TODO: send to the chans
    # TODO: use something like msg.sender.user instead of "user"
    chans.each { |chan| msg.sender.notice CrystalIrc::User.new("user"), "JOINED #{chan.name}" }
  end
  spawn server_process_client(s, s.accept)
  loop do
    sleep 1
  end
end

start
