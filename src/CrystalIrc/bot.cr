require "./client"

module CrystalIrc
  class Bot < Client

    alias Hook = (String) -> Bool

    @hooks : Hash(String, Array(Hook))

    def initialize(**opts)
      super(**opts)
      @hooks = Hash(String, Array(Hook)).new
    end

    def on(msg : String, hook : Hook) : CrystalIrc::Bot
      @hooks.fetch(msg) { @hooks[msg] = Array(Hook).new }
      @hooks[msg] << hook
      self
    end

    def handle(msg : String)
      cmd = msg.split(" ").first
      @hooks.fetch(cmd){ Array(Hook).new }.each{|hook| hook.call(msg)}
      self
    end

  end
end
