require "./CrystalIrc"

def server_process_client(s, cli)
  cli.send_raw ":127.0.0.1 NOTICE Auth :*** Connecting..."
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
    if client.valid
      # Broadcast nick to all users who share a chan
      # TODO broadcast only to concerned clients (self + share a chan)
      s.clients.each { |u| u.send_raw ":#{client.user.nick} NICK :#{msg.raw_arguments.to_s}" }
    end
    client.user.nick = msg.raw_arguments.to_s
  end.on("USER") do |msg|
    client = s.clients.select { |e| e.user.nick == msg.sender.from }.first?
    raise CrystalIrc::IrcError.new if client.nil?
    client.username = msg.raw_arguments.to_s.split(" ")[0]
    client.realname = msg.raw_arguments.to_s.split(":")[1]
    msg.sender.answer_raw "001 #{client.user.nick} :Welcome to PonyServ"
    msg.sender.answer_raw "002 #{client.user.nick} :Host is 127.0.0.1"
    msg.sender.answer_raw "003 #{client.user.nick} :This server was created on..."
    msg.sender.answer_raw "004 #{client.user.nick} 127.0.0.1 v001 BHIRSWacdhikorswx ABCDFKLMNOQRSTYZabcefghijklmnopqrstuvz FLYZabefghjkloq" # TODO put right stuff here
    client.validate
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
      # TODO broadcast only to clients in chan? (Maybe chan should have client list and not user list?)
      s.clients.each { |u| u.send_raw ":#{client.user.nick} JOIN :#{chan.name}" }
      # TODO send user list & motd
    end
  end.on("PASS") do |msg| # TODO not implemented
  end.on("CAP") do |msg|
    client = s.clients.select { |e| e.user.nick == msg.sender.from }.first?
    raise CrystalIrc::IrcError.new if client.nil?
    if msg.raw_arguments.to_s.split(" ")[0] == "LS"
      client.send_raw(":127.0.0.1 CAP 203BAN0L5 LS :")
    elsif msg.raw_arguments.to_s.split(" ")[0] == "REQ"
      client.send_raw(":127.0.0.1 CAP 203BAN0MN ACK :")
    end
  end
  spawn server_process_client(s, s.accept)
  loop do
    sleep 1
  end
end

start
