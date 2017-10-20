require "./CrystalIrc"

def server_process_client(s, cli)
  cli.send_raw "001 Default :Welcome to PonyServ"
  # BUG: Expect at least a NICK to send 001 connected, but the server doesn't recognize NICK commands without this
  # TODO: putting :Default nickname is a quick&dirty fix that should not be here
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
  s.on("WHOIS") do |msg|
    msg.sender.answer_raw "311 #{msg.raw_arguments.to_s} #{msg.raw_arguments.to_s} ~#{msg.raw_arguments.to_s} 0 * ok@ok"
  end.on("NICK") do |msg|
    # Check for availability & validity of nick
    if !msg.raw_arguments.to_s.match(/\A(?!.{51,})((#{CrystalIrc::User::CHARS_FIRST})((#{CrystalIrc::User::CHARS_NEXT})+))\Z/)
      msg.sender.answer_raw "432 :#{msg.raw_arguments.to_s} :Erroneus nickname"
      next
    end
    s.clients.each do |cli|
      if cli.user.nick == msg.raw_arguments.to_s
        msg.sender.answer_raw "433 :#{msg.raw_arguments.to_s} :Nickname is already in use"
        next
      end
    end
    # Change the nick of the user
    client = s.clients.select { |e| e.user.nick == msg.sender.from }.first?
    raise CrystalIrc::IrcError.new if client.nil?
    # Broadcast nick to all users who share a chan
    # TODO
    msg.sender.send_raw ":#{client.user.nick} NICK :#{msg.raw_arguments.to_s}" # only notifies the concerned user for now
    client.user.nick = msg.raw_arguments.to_s
  end.on("USER") do |msg|
    msg.sender.answer_raw "462 #{msg.raw_arguments.to_s} : nop"
  end.on("JOIN") do |msg|
    chans = msg.raw_arguments.to_s.split(",").map { |e| CrystalIrc::Chan.new e.strip }
    chans.each do |c|
      chan = s.chans.select { |e| e.name == c.name }.first?
      if chan.nil?
        # Add chan to chan list if new
        s.chans << c
        chan = c
      end
      # Get user
      client = s.clients.select { |e| e.user.nick == msg.sender.from }.first?
      raise CrystalIrc::IrcError.new if client.nil?
      # Add user to the chan's user list
      chan.users << client.user if !client.nil?
      chan.users.each do |u|
        msg.sender.send_raw ":#{client.user.nick} JOIN :#{chan.name}"
      end
      # TODO send user list & motd
    end
  end
  spawn server_process_client(s, s.accept)
  loop do
    sleep 1
  end
end

start
