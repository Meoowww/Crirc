module CrystalIrc
  # Represent a message.
  # It has a sender, a command (or a code).
  # Optionaly, it may have a source, arguments, and message.
  class Message
    @raw : String
    @source : String?
    @command : String
    @arguments : String?
    @message : String?
    @sender : CrystalIrc::IrcSender

    getter raw, source, command, message, sender

    # Return the arguments value
    # This is a litteral `String`.
    # Each arguments are separated with space (the last may contain spaces, but
    # in this case, the last argument follows a ':')
    def raw_arguments : String
      return "" if @arguments.nil? && @message.nil?
      return @arguments.as(String) if @message.nil?
      return ":#{@message}" if @arguments.nil?
      return "#{@arguments} :#{@message}"
    end

    def arguments : Array(String)
      return Array(String).new if @arguments.nil? && @message.nil?
      return (@arguments.as(String)).split(" ") if @message.nil?
      return [@message.as(String)] if @arguments.nil?
      return (@arguments.as(String)).split(" ") << (@message.as(String))
    end

    R_SRC     = "(\\:(?<src>[^[:space:]]+) )"
    R_CMD     = "(?<cmd>[A-Z]+|\\d{3})"
    R_ARG_ONE = "(?:[^: ][^ ]*)"
    R_ARG     = "(?: (?<arg>#{R_ARG_ONE}(?: #{R_ARG_ONE})*))"
    R_MSG     = "(?: \\:(?<msg>.+))"

    def initialize(@raw, @sender)
      m = raw.strip.match(/\A#{R_SRC}?#{R_CMD}#{R_ARG}?#{R_MSG}?\Z/)
      raise ParsingError.new(raw, "message invalid") if m.nil?
      @source = m["src"]?
      @command = m["cmd"] # ? || raise InvalidMessage.new("No command to parse in \"#{raw}\"")
      @arguments = m["arg"]?
      @message = m["msg"]?
    end

    # TODO: if a chan is associated (eg: message emit in a chan)
    def chan : Chan
      if @command == "PRIVMSG" && !arguments.nil? && !arguments.empty? && arguments[0][0] == '#'
        Chan.new arguments[0]
      else
        raise NotImplementedError.new "No chan availiable"
      end
    end

    # TODO: if an user is associated (eg: privmsg, ...)
    def user : User
      if @command == "PRIVMSG" && !arguments.nil? && !arguments.empty? && arguments[0][0] != '#'
        User.new arguments[0]
      else
        raise NotImplementedError.new "No user availiable"
      end
    end

    def reply(msg : String)
      target = user rescue chan rescue raise NotImplementedError.new "No chan nor user availiable"
      @sender.privmsg(target, msg)
    end
  end
end
