require "./client"

module CrystalIrc
  class Bot < Client

    alias Hook = (CrystalIrc::Bot, String, String) -> Bool

    @hooks : Hash(String, Array(Hook))

    def initialize(**opts)
      super(**opts)
      @hooks = Hash(String, Array(Hook)).new
    end

    # Register a hook on a command name (JOIN, PRIVMSG, ...)
    def on(msg : String, hook : Hook) : CrystalIrc::Bot
      @hooks.fetch(msg) { @hooks[msg] = Array(Hook).new }
      @hooks[msg] << hook
      self
    end

    # TODO: use look ahead assert to check the " " without rm <args> and without .strip
    def handle(msg : String)
      m = msg.match(/\A\:(?<source>[^[:space:]]+) (?<cmd>[A-Z]+)(?<args>.*)/)
      raise InvalidMessage.new(msg) if m.nil?
      @hooks.fetch(m["cmd"]){ Array(Hook).new }.each do |hook|
        hook.call(self, m["source"], m["args"].strip)
      end
      self
    end

  end
end
