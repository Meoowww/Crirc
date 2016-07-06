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

    def initialize(raw : String, @sender)
      m = raw.strip.match(/\A(\:(?<source>[^[:space:]]+) )?(?<cmd>[A-Z]+)(?: (?<args>[^\:]*))?(?: \:(?<msg>.+))?\Z/)
      raise InvalidMessage.new("Cannot parse the message \"#{raw}\"") if m.nil?
      @source = m["source"]?
      @command = m["cmd"] # ? || raise InvalidMessage.new("No command to parse in \"#{raw}\"")
      @arguments = m["args"]?
      @message = m["msg"]?
    end
  end
end
