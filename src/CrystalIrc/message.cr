require "./client"

module CrystalIrc
  class Message

    @source     : String
    @command    : String
    @arguments  : String
    @client     : CrystalIrc::Client

    getter source, command, arguments

    def initialize(raw : String, @client)
      m = raw.match(/\A\:(?<source>[^[:space:]]+) (?<cmd>[A-Z]+)(?<args>.*)/)
      raise InvalidMessage.new("Cannot parse the message \"raw\"") if m.nil?
      @source = m["source"]
      @command = m["cmd"]
      @arguments = m["args"].strip
    end

  end
end
