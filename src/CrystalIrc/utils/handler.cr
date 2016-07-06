module CrystalIrc
  # Register hooks to handle the behavior of a system based on a message.
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
    alias Hook = (CrystalIrc::Message) ->

    # Register a hook on a command name (JOIN, PRIVMSG, ...) and other rules
    def on(command : String, source : HookRule = nil, arguments : HookRule = nil, message : HookRule = nil, &hook : Hook)
      rule = CrystalIrc::Bot::HookRules.new(command, source, arguments, message)
      self.hooks.fetch(rule) { self.hooks[rule] = Array(Hook).new }
      self.hooks[rule] << hook
      self
    end

    def handle(msg : CrystalIrc::Message)
      self.hooks.select { |rule, hooks| rule.test(msg) }.each { |_, hooks| hooks.each { |hook| hook.call(msg) } }
      self.hooks.fetch(msg.command) { Array(Hook).new }
      self
    end

    def handle(msg : String, sender = self)
      handle(CrystalIrc::Message.new msg, sender)
    end
  end
end
