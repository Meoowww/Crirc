# Default binding on the server.
# Handles the classic behavior of a server.
module CrystalIrc::Server::Binding
  def self.rpl_topic(client, chan)
    if (motd = chan.motd).nil?
      client.send_raw ":0 331 #{client.user.nick} #{chan.name} :No topic is set"
    else
      client.send_raw ":0 332 #{client.user.nick} #{chan.name} :#{motd.message}"
      # TODO put user address and not just name
      client.send_raw ":0 333 #{client.user.nick} #{chan.name} #{motd.user} #{motd.timestamp}"
    end
  end

  def self.attach(obj)
    self.bind_ping obj
    self.bind_whois obj
    self.bind_nick obj
    self.bind_user obj
    self.bind_join obj
    self.bind_mode obj
    self.bind_part obj
    self.bind_pass obj
    self.bind_cap obj
    self.bind_topic obj
    self.bind_message obj
  end

  def self.bind_ping(obj)
    obj.on("PING") { |msg| msg.sender.pong msg.message }
  end

  # TODO: read which infos we must send
  def self.bind_whois(obj)
    obj.on("WHOIS") do |msg|
      msg.sender.send_raw ":0 311 #{msg.raw_arguments.to_s} #{msg.raw_arguments.to_s} ~#{msg.raw_arguments.to_s} 0 * ok@ok"
    end
  end

  def self.bind_nick(obj) # BUG: when several persons connect at once, they get confused...
    obj.on("NICK") do |msg|
      obj.mut.lock
      # Check for availability & validity of nick
      if !msg.arguments[0].match(/\A(?!.{51,})((#{CrystalIrc::User::CHARS_FIRST})((#{CrystalIrc::User::CHARS_NEXT})+))\Z/)
        msg.sender.send_raw ":0 432 :#{msg.arguments[0]} :Erroneus nickname"
        obj.mut.unlock
        next
      end
      obj.clients.each do |cli|
        if cli.user.nick == msg.arguments[0]
          msg.sender.send_raw ":0 433 :#{msg.arguments[0]} :Nickname is already in use"
          obj.mut.unlock
          next
        end
      end
      # Change the nick of the user
      client = obj.clients.find { |e| e.user.nick == msg.sender.from }
      raise CrystalIrc::IrcError.new if client.nil?
      if client.valid?
        msg.sender.send_raw ":#{client.user.nick} NICK :#{msg.raw_arguments.to_s}"
        # Broadcast nick to all users who share a chan
        obj.chans.each do |c|
          # Send nick to users who share a chan
          # TODO: avoid duplicates
          chan, userlist = c
          if userlist.find { |e| e.user.nick == msg.sender.from }.nil?
            obj.mut.unlock
            next
          end
          userlist.each { |u| u.send_raw ":#{client.user.nick} NICK :#{msg.raw_arguments.to_s}" }
        end
      else
        client.validate  CrystalIrc::Server::Client::ValidationStates::Nick
      end
      client.user.nick = msg.arguments[0]
      obj.mut.unlock
    end
  end

  # TODO put right stuff in the 004 reply
  def self.bind_user(obj)
    obj.on("USER") do |msg|
      client = obj.clients.find { |e| e.user.nick == msg.sender.from }
      raise CrystalIrc::IrcError.new if client.nil?
      if msg.arguments.size < 4 || msg.message.nil?
        msg.sender.send_raw ":0 461 #{msg.sender.from} USER :Not enough parameters"
        next
      elsif client.valid == (CrystalIrc::Server::Client::ValidationStates::User || CrystalIrc::Server::Client::ValidationStates::Valid)
        msg.sender.send_raw ":0 462 #{msg.sender.from} :Unauthorized command (already registered)"
      end

      client.username = msg.arguments[0]
      message = msg.message
      client.realname = message unless message.nil?

      msg.sender.send_raw ":0 001 #{client.user.nick} :Welcome to PonyServ"
      msg.sender.send_raw ":0 002 #{client.user.nick} :Host is 127.0.0.1"
      msg.sender.send_raw ":0 003 #{client.user.nick} :This server was created on..."
      msg.sender.send_raw ":0 004 #{client.user.nick} 127.0.0.1 v001 BHIRSWacdhikorswx ABCDFKLMNOQRSTYZabcefghijklmnopqrstuvz FLYZabefghjkloq"
      client.validate CrystalIrc::Server::Client::ValidationStates::User
    end
  end

  def self.bind_join(obj)
    obj.on("JOIN") do |msg|
      client = obj.clients.find { |e| e.user.nick == msg.sender.from }
      raise CrystalIrc::IrcError.new if client.nil?
      chans = msg.arguments[0].split(",").map { |e| CrystalIrc::Chan.new e.strip }
      if chans.size == 0
        msg.sender.send_raw ":0 461 #{msg.sender.from} JOIN :Not enough parameters"
        next
      end
      chans.each do |c|
        chan_tuple = obj.chans.find { |e| e[0].name == c.name }
        if chan_tuple.nil?
          # Add chan to chan list if new
          obj.chans[c] = [] of CrystalIrc::Server::Client
          chan_tuple = obj.chans.find { |e| e[0].name == c.name }
          raise CrystalIrc::IrcError.new if chan_tuple.nil?
        end
        chan, userlist = chan_tuple
        # Check if user already in the chan
        next if userlist.includes? client
        # Add user to the chan's user list
        chan.users << client.user
        userlist << client

        # Broadcast the join to chan
        userlist.each { |u| u.send_raw ":#{client.user.nick} JOIN :#{chan.name}" }

        # Send user list & motd & mode
        self.rpl_topic client, chan

        # This is the answer to the user list command, so should be in a separate function
        userlist_response = String::Builder.new
        userlist.join(" ", userlist_response) { |u, io| io << "#{u.user.nick}" }
        msg.sender.send_raw ":0 353 #{msg.sender.from} = #{chan.name} :#{userlist_response.to_s}"
        msg.sender.send_raw ":0 366 #{msg.sender.from} #{chan.name} :End of /NAMES list."
      end
    end
  end

  def self.bind_mode(obj)
    obj.on("MODE") do |msg|
      # TODO mode is not always on a chan, can be on a user !
      if msg.arguments.size == 0
        msg.sender.send_raw ":0 461 #{msg.sender.from} MODE :Not enough parameters"
      elsif msg.arguments[0].chars[0] == '#' # chan
        c = CrystalIrc::Chan.new msg.arguments[0]
        chan = obj.chans.select { |e| e.name == c.name }.first?
        raise CrystalIrc::IrcError.new if chan.nil?
        chan = chan[0]
        if msg.arguments.size > 1
          # TODO check if mode is valid
          # TODO handle mode effects in chan class
          if msg.arguments[1].chars.first == '+'
            chan.modes += msg.arguments[1]
            chan.modes = chan.modes.delete '+'
          elsif msg.arguments[1].chars.first == '-'
            msg.arguments[1].chars.each do |c|
              chan.modes = chan.modes.delete c
            end
          else
            # TODO: MODE #chan b for ex gives ban list and only ban list
          end
          chan.modes = chan.modes.chars.uniq!.join("")
        end
        msg.sender.send_raw ":0 324 #{msg.sender.from} #{chan.name} +#{chan.modes}"
        # TODO handle 329 which is not in RFC 2812
      else # user
        if msg.arguments[0] != msg.sender.from
          msg.sender.send_raw ":0 402 #{msg.sender.from} :Cannot change mode for other users"
        else
          # TODO
        end
      end
    end
  end

  def self.bind_part(obj)
    obj.on("PART") do |msg|
      client = obj.clients.find { |e| e.user.nick == msg.sender.from }
      raise CrystalIrc::IrcError.new if client.nil?
      chans = msg.arguments[0].split(",").map { |e| CrystalIrc::Chan.new e.strip }
      if chans.size == 0
        msg.sender.send_raw ":0 461 #{msg.sender.from} PART :Not enough parameters"
        next
      end
      chans.each do |c|
        chan_tuple = obj.chans.find { |e| e[0].name == c.name }
        next if chan_tuple.nil?
        chan, userlist = chan_tuple
        userlist.delete(client)
        chan.users.delete(client.user)

        # Broadcast PART to users in the chan + client
        msg.sender.send_raw ":#{client.user.nick} PART #{chan.name} :#{msg.raw_arguments.to_s.split(":")[1]}"
        if msg.message.nil?
          userlist.each { |u| u.send_raw ":#{client.user.nick} PART #{chan.name} :#{msg.raw_arguments.to_s.split(":")[1]}" }
        else
          userlist.each { |u| u.send_raw ":#{client.user.nick} PART #{chan.name}" }
        end
        chans.delete(chan) if userlist.empty?
      end
    end
  end

  # TODO not implemented
  def self.bind_pass(obj)
    obj.on("PASS") do |msg|
    end
  end

  def self.bind_cap(obj)
    obj.on("CAP") do |msg|
      client = obj.clients.find { |e| e.user.nick == msg.sender.from }
      raise CrystalIrc::IrcError.new if client.nil?
      if msg.arguments[0] == "LS"
        client.send_raw ":0 CAP 203BAN0L5 LS :"
      elsif msg.arguments[0] == "REQ"
        client.send_raw ":0 CAP 203BAN0MN ACK :"
      end
    end
  end

  def self.bind_topic(obj)
    obj.on("TOPIC") do |msg|
      c = CrystalIrc::Chan.new msg.arguments[0]
      chan_tuple = obj.chans.find { |e| e[0].name == c.name }
      if chan_tuple.nil?
        msg.sender.send_raw ":0 461 #{msg.sender.from} JOIN :Not enough parameters"
        next
      end
      chan, userlist = chan_tuple
      if msg.arguments.size > 1
        if (motd = chan.motd).nil? && !(message = msg.message).nil?
          chan.motd = CrystalIrc::Chan::Motd.new message, msg.sender.from
        elsif !motd.nil? && !message.nil?
          motd.set_motd message, msg.sender.from
        end
      end
      # Send back topic
      # TODO send it to everyone in chan!
      userlist.each { |u| self.rpl_topic u, chan }
    end
  end

  def self.bind_message(obj) # TODO handle all error cases
    obj.on("PRIVMSG") do |msg|
      # Message on chan
      if msg.arguments[0][0] == '#'
        c = CrystalIrc::Chan.new msg.arguments[0]
        chan_tuple = obj.chans.find { |e| e[0].name == c.name }
        raise CrystalIrc::IrcError.new if chan_tuple.nil?
        chan, userlist = chan_tuple
        # Check if user is in chan
        if userlist.find { |e| e.user.nick == msg.sender.from }.nil?
          msg.sender.send_raw ":0 404 #{msg.sender.from} #{msg.arguments[0]} :Cannot send to channel"
          next
        end
        userlist.each { |u| u.send_raw ":#{msg.sender.from} PRIVMSG #{msg.arguments[0]} :#{msg.message}" if u.user.nick != msg.sender.from }
      else # Private message
      end
    end
  end
end
