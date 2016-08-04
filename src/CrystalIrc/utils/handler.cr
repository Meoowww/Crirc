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
    alias Hook = (CrystalIrc::Message, Regex::MatchData?) ->

    # Register a hook on a command name (JOIN, PRIVMSG, ...) and other rules
    def on(command : String, source : HookRule = nil, arguments : HookRule = nil, message : HookRule = nil, &hook : Hook)
      rule = CrystalIrc::Bot::HookRules.new(command, source, arguments, message)
      self.hooks.fetch(rule) { self.hooks[rule] = Array(Hook).new }
      self.hooks[rule] << hook
      self
    end

    # Handle one `Message`
    # It goes through the registred hooks, select the one to trigger.
    # Then, it execute every hooks associated, and send as parameters the current message and the regex match if possible
    # TODO: msg should NEVER be modified in the hook. (copy ? readonly ?)
    def handle(msg : CrystalIrc::Message)
      selected_hooks = self.hooks.select { |rule, hooks| rule.test(msg) }
      selected_hooks.each do |rule, hooks|
        hooks.each do |hook|
          match = msg.message && rule.message.is_a?(Regex) ? (rule.message.as(Regex)).match(msg.message.as(String)) : nil
          hook.call(msg, match)
        end
      end
      self.hooks.fetch(msg.command) { Array(Hook).new }
      self
    end

    def handle(msg : String, sender = self)
      handle(CrystalIrc::Message.new msg, sender)
    end
  end
end
