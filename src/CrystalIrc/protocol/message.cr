module CrystalIrc
  class Message
    @source : String?
    @command : String
    @arguments : String?
    @message : String?
    @sender : CrystalIrc::IrcSender

    getter source, command, message, sender

    # @return an Array of Arguments, including the message (last argument with the prefix :)
    def arguments : Array(String)
      (@arguments ? @arguments.to_s.split(" ") + [@message] : [@message]).compact
    end

    # @return the arguments value (litteral string or nil with space to separate arguments, wich not includes the message)
    def raw_arguments : String?
      @arguments
    end

    R_SRC = "(\\:(?<src>[^[:space:]]+) )"
    R_CMD = "(?<cmd>[A-Z]+|\\d{3})"
    R_ARG_ONE = "(?:[^: ][^ ]*)"
    R_ARG = "(?: (?<arg>#{R_ARG_ONE}(?: #{R_ARG_ONE})*))"
    R_MSG = "(?: \\:(?<msg>.+))"
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
