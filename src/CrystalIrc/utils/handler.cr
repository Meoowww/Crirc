module CrystalIrc
  module Handler
    @hooks : Hash(CrystalIrc::Handler::HookRules, Array(CrystalIrc::Handler::Hook))

    def initialize(**opts)
      super(**opts)
      @hooks = Hash(CrystalIrc::Handler::HookRules, Array(CrystalIrc::Handler::Hook)).new
    end

    protected def hooks
      @hooks
    end

    alias HookRule = String | Regex | Nil
    alias Hook = (CrystalIrc::Bot, CrystalIrc::Message) ->

    # Register a hook on a command name (JOIN, PRIVMSG, ...) and other rules
    def on(command : String, source : HookRule = nil, arguments : HookRule = nil, message : HookRule = nil, &hook : Hook)
      rule = CrystalIrc::Bot::HookRules.new(command, source, arguments, message)
      self.hooks.fetch(rule) { self.hooks[rule] = Array(Hook).new }
      self.hooks[rule] << hook
      self
    end

    def handle(msg : CrystalIrc::Message)
      self.hooks.select{|rule, hooks| rule.test(msg)}.each{|_, hooks| hooks.each{|hook| hook.call(self, msg)} }
      self.hooks.fetch(msg.command){ Array(Hook).new }
      self
    end

    def handle(msg : String)
      handle(CrystalIrc::Message.new msg, self)
    end

  end
end
