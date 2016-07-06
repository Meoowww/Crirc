module CrystalIrc
  # Represent a message.
  # It has a sender, a command (or a code).
  # Optionaly, it may have a source, arguments, and message.
  class Message
    @source : String?
    @command : String
    @arguments : String?
    @message : String?
    @sender : CrystalIrc::IrcSender

    getter source, command, message, sender

    # Return an Array of Arguments, including the message.
    def arguments : Array(String)
      (@arguments ? @arguments.to_s.split(" ") + [@message] : [@message]).compact
    end

    # Return the arguments value
    # This is a litteral string or nil.
    # Each arguments are separated with space
    # It does not include the message.
    def raw_arguments : String?
      @arguments
    end

    R_SRC     = "(\\:(?<src>[^[:space:]]+) )"
    R_CMD     = "(?<cmd>[A-Z]+|\\d{3})"
    R_ARG_ONE = "(?:[^: ][^ ]*)"
    R_ARG     = "(?: (?<arg>#{R_ARG_ONE}(?: #{R_ARG_ONE})*))"
    R_MSG     = "(?: \\:(?<msg>.+))"

    def initialize(raw : String, @sender)
      m = raw.strip.match(/\A#{R_SRC}?#{R_CMD}#{R_ARG}?#{R_MSG}?\Z/)
      raise ParsingError.new(raw, "message invalid") if m.nil?
      @source = m["src"]?
      @command = m["cmd"] # ? || raise InvalidMessage.new("No command to parse in \"#{raw}\"")
      @arguments = m["arg"]?
      @message = m["msg"]?
    end
  end
end
