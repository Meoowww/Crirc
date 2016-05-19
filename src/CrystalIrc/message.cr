require "./client"

module CrystalIrc
  class Message

    @source     : String?
    @command    : String
    @arguments  : String?
    @message    : String?
    @client     : CrystalIrc::Client

    getter source, command, arguments, message

    def initialize(raw : String, @client)
      m = raw.match(/\A(\:(?<source>[^[:space:]]+) )?(?<cmd>[A-Z]+)(?: (?<args>[^\:]*))?(?: \:(?<msg>.+))?\Z/)
      raise InvalidMessage.new("Cannot parse the message \"#{raw}\"") if m.nil?
      @source = m["source"]?
      @command = m["cmd"] #? || raise InvalidMessage.new("No command to parse in \"#{raw}\"")
      @arguments = m["args"]?
      @message = m["msg"]?
    end

  end
end
