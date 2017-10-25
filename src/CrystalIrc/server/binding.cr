# Default binding on the server.
# Handles the classic behavior of a server.
module CrystalIrc::Server::Binding
  def self.rpl_topic(msg, chan)
    if (motd = chan.motd).nil?
      msg.sender.send_raw "331 #{msg.sender.from} #{chan.name} :No topic is set"
    else
      msg.sender.send_raw "332 #{msg.sender.from} #{chan.name} :#{motd.message}"
      # TODO put user address and not just name
      msg.sender.send_raw "333 #{msg.sender.from} #{chan.name} #{motd.user} #{motd.timestamp}"
    end
  end

  def self.attach(obj)
    obj.on("PING") do |msg|
      msg.sender.pong(msg.message)
    end.on("WHOIS") do |msg|
        msg.sender.answer_raw "311 #{msg.raw_arguments.to_s} #{msg.raw_arguments.to_s} ~#{msg.raw_arguments.to_s} 0 * ok@ok"
    end.on("NICK") do |msg|
      # Check for availability & validity of nick
      if !msg.raw_arguments.to_s.match(/\A(?!.{51,})((#{CrystalIrc::User::CHARS_FIRST})((#{CrystalIrc::User::CHARS_NEXT})+))\Z/)
        msg.sender.answer_raw "432 :#{msg.raw_arguments.to_s} :Erroneus nickname"
        next
      end
      obj.clients.each do |cli|
        if cli.user.nick == msg.raw_arguments.to_s
          msg.sender.answer_raw "433 :#{msg.raw_arguments.to_s} :Nickname is already in use"
          next
        end
      end
      # Change the nick of the user
      client = obj.clients.select { |e| e.user.nick == msg.sender.from }.first?
      raise CrystalIrc::IrcError.new if client.nil?
      if client.valid
        # Broadcast nick to all users who share a chan
        # TODO broadcast only to concerned clients (self + share a chan)
        obj.clients.each { |u| u.send_raw ":#{client.user.nick} NICK :#{msg.raw_arguments.to_s}" }
      end
      client.user.nick = msg.raw_arguments.to_s
    end.on("USER") do |msg|
      client = obj.clients.select { |e| e.user.nick == msg.sender.from }.first?
      raise CrystalIrc::IrcError.new if client.nil?
      client.username = msg.raw_arguments.to_s.split(" ")[0]
      if msg.raw_arguments.to_s.split(":").size > 0
        client.realname = msg.raw_arguments.to_s.split(":")[1]
      else
        client.realname = msg.raw_arguments.to_s.split(" ")[3]
      end
      msg.sender.answer_raw "001 #{client.user.nick} :Welcome to PonyServ"
      msg.sender.answer_raw "002 #{client.user.nick} :Host is 127.0.0.1"
      msg.sender.answer_raw "003 #{client.user.nick} :This server was created on..."
      msg.sender.answer_raw "004 #{client.user.nick} 127.0.0.1 v001 BHIRSWacdhikorswx ABCDFKLMNOQRSTYZabcefghijklmnopqrstuvz FLYZabefghjkloq" # TODO put right stuff here
      client.validate
    end.on("JOIN") do |msg|
      client = obj.clients.select { |e| e.user.nick == msg.sender.from }.first?
      raise CrystalIrc::IrcError.new if client.nil?
      chans = msg.raw_arguments.to_s.split(",").map { |e| CrystalIrc::Chan.new e.strip }
      if chans.size == 0
        msg.sender.send_raw "461 #{msg.sender.from} JOIN :Not enough parameters"
        raise CrystalIrc::IrcError.new
      end
      chans.each do |c|
        chan = obj.chans.select { |e| e.name == c.name }.first?
        if chan.nil?
          # Add chan to chan list if new
          obj.chans << c
          chan = c
        end
        # Check if user already in the chan
        next if chan.users.includes? client.user
        # Add user to the chan's user list
        chan.users << client.user
        # TODO broadcast only to clients in chan? (Maybe chan should have client list and not user list?)
        obj.clients.each { |u| u.send_raw ":#{client.user.nick} JOIN :#{chan.name}" }

        # Send user list & motd & mode
        self.rpl_topic(msg, chan)

        # This is the answer to the user list command, so should be in a separate function
        userlist = String::Builder.new
        chan.users.join(" ", userlist) { |u, io| io << "#{u.nick}" }
        msg.sender.send_raw "353 #{msg.sender.from} = #{chan.name} :#{userlist.to_s}"
        msg.sender.send_raw "366 #{msg.sender.from} #{chan.name} :End of /NAMES list."
      end
    end.on("MODE") do |msg|
      c = CrystalIrc::Chan.new msg.raw_arguments.to_s.split(" ")[0]
      chan = obj.chans.select { |e| e.name == c.name }.first?
      if chan.nil?
        msg.sender.send_raw "461 #{msg.sender.from} MODE :Not enough parameters"
        raise CrystalIrc::IrcError.new
      end
      if msg.raw_arguments.to_s.split(" ").size > 1
        # TODO check if mode is valid
        # TODO handle mode effects in chan class
        if msg.raw_arguments.to_s.split(" ")[1].chars.first == '+'
          chan.modes += msg.raw_arguments.to_s.split(" ")[1]
          chan.modes = chan.modes.delete '+'
        elsif msg.raw_arguments.to_s.split(" ")[1].chars.first == '-'
          msg.raw_arguments.to_s.split(" ")[1].chars.each do |c|
            chan.modes = chan.modes.delete c
          end
        else
          # TODO
        end
        chan.modes = chan.modes.chars.uniq!.join("")
        msg.sender.send_raw "324 #{msg.sender.from} #{chan.name} +#{chan.modes}"
      else
        msg.sender.send_raw "324 #{msg.sender.from} #{chan.name} +#{chan.modes}"
      end
      # TODO handle 329 which is not in RFC 2812
    end.on("PART") do |msg|
      client = obj.clients.select { |e| e.user.nick == msg.sender.from }.first?
      raise CrystalIrc::IrcError.new if client.nil?
      chans = msg.raw_arguments.to_s.split(":")[0].split(",").map { |e| CrystalIrc::Chan.new e.strip }
      if chans.size == 0
        msg.sender.send_raw "461 #{msg.sender.from} PART :Not enough parameters"
        raise CrystalIrc::IrcError.new
      end
      chans.each do |c|
        chan = obj.chans.select { |e| e.name == c.name }.first?
        next if chan.nil?
        chan.users.delete(client.user)
        # TODO broadcast only to clients in chan? (Maybe chan should have client list and not user list?)
        if msg.raw_arguments.to_s.split(":").size > 1
          obj.clients.each { |u| u.send_raw ":#{client.user.nick} PART #{chan.name} :#{msg.raw_arguments.to_s.split(":")[1]}" }
        else
          obj.clients.each { |u| u.send_raw ":#{client.user.nick} PART #{chan.name}" }
        end
        chans.delete(chan) if chan.users.empty?
      end
    end.on("PASS") do |msg| # TODO not implemented
    end.on("CAP") do |msg|
      client = obj.clients.select { |e| e.user.nick == msg.sender.from }.first?
      raise CrystalIrc::IrcError.new if client.nil?
      if msg.raw_arguments.to_s.split(" ")[0] == "LS"
        client.send_raw(":127.0.0.1 CAP 203BAN0L5 LS :")
      elsif msg.raw_arguments.to_s.split(" ")[0] == "REQ"
        client.send_raw(":127.0.0.1 CAP 203BAN0MN ACK :")
      end
    end.on("TOPIC") do |msg|
      c = CrystalIrc::Chan.new msg.raw_arguments.to_s.split(" ")[0]
      chan = obj.chans.select { |e| e.name == c.name }.first?
      if chan.nil?
        msg.sender.send_raw "461 #{msg.sender.from} JOIN :Not enough parameters"
        raise CrystalIrc::IrcError.new
      end
      if msg.raw_arguments.to_s.split(" ").size > 1
        if (motd = chan.motd).nil?
          chan.motd = CrystalIrc::Chan::Motd.new msg.raw_arguments.to_s.split(":")[1], msg.sender.from
        else
          motd.setMotd msg.raw_arguments.to_s.split(":")[1], msg.sender.from
        end
      end
      # Send back topic
      self.rpl_topic(msg, chan)
    end
  end
end
