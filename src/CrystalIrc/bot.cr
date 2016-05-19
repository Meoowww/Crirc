require "./client"

module CrystalIrc
  class Bot < Client

    alias HookRule = String | Regex | Nil
    alias Hook = (CrystalIrc::Bot, CrystalIrc::Message) ->

    @hooks : Hash(CrystalIrc::HookRules, Array(Hook))

    def initialize(**opts)
      super(**opts)
      @hooks = Hash(CrystalIrc::HookRules, Array(Hook)).new
    end

    # Register a hook on a command name (JOIN, PRIVMSG, ...) and other rules
    def on(command : String, source : HookRule = nil, arguments : HookRule = nil, message : HookRule = nil, &hook : Hook) : CrystalIrc::Bot
      rule = CrystalIrc::HookRules.new(command, source, arguments, message)
      @hooks.fetch(rule) { @hooks[rule] = Array(Hook).new }
      @hooks[rule] << hook
      self
    end

    def handle(msg : CrystalIrc::Message) : CrystalIrc::Bot
      @hooks.select{|rule, hooks| rule.test(msg)}.each{|_, hooks| hooks.each{|hook| hook.call(self, msg)} }
      @hooks.fetch(msg.command){ Array(Hook).new }
      self
    end

    def handle(msg : String) : CrystalIrc::Bot
      handle(CrystalIrc::Message.new msg, self)
    end

  end
end
