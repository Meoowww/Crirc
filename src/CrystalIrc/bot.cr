require "./client"

module CrystalIrc
  class Bot < Client

    alias Hook = (CrystalIrc::Bot, CrystalIrc::Message) ->

    @hooks : Hash(String, Array(Hook))

    def initialize(**opts)
      super(**opts)
      @hooks = Hash(String, Array(Hook)).new
    end

    # Register a hook on a command name (JOIN, PRIVMSG, ...)
    def on(msg : String, &hook : Hook) : CrystalIrc::Bot
      @hooks.fetch(msg) { @hooks[msg] = Array(Hook).new }
      @hooks[msg] << hook
      self
    end

    def handle(msg : CrystalIrc::Message) : CrystalIrc::Bot
      @hooks.fetch(msg.command){ Array(Hook).new }.each do |hook|
        hook.call(self, msg)
      end
      self
    end

    def handle(msg : String) : CrystalIrc::Bot
      handle(CrystalIrc::Message.new msg, self)
    end

  end
end
