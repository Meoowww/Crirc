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

    R_SOURCE = "(\\:(?<source>[^[:space:]]+) )"
    R_CMD = "(?<cmd>[A-Z]+|\\d{3})"
    R_ARGS_ONE = "(?:[^: ][^ ]*)"
    R_ARGS = "(?: (?<args>#{R_ARGS_ONE}(?: #{R_ARGS_ONE})*))"
    R_MSG = "(?: \\:(?<msg>.+))"
    def initialize(raw : String, @sender)
      m = raw.strip.match(/\A#{R_SOURCE}?#{R_CMD}#{R_ARGS}?#{R_MSG}?\Z/)
      raise InvalidMessage.new("Cannot parse the message \"#{raw}\"") if m.nil?
      @source = m["source"]?
      @command = m["cmd"] # ? || raise InvalidMessage.new("No command to parse in \"#{raw}\"")
      @arguments = m["args"]?
      @message = m["msg"]?
    end
  end
end
