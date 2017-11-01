require "./hook_test"

# Register hooks to handle the behavior of a system based on a message.
module Crirc::Binding::Handler
  alias HookRule = String | Regex | Nil
  alias Hook = (Crirc::Protocol::Message, Regex::MatchData?) ->

  getter hooks : Hash(HookRule, Array(Hook))

  def initialize(**opts)
    super(**opts)
    @hooks = Hash(HookTest, Array(Hook)).new
  end

  # Register a hook on a command name (JOIN, PRIVMSG, ...) and other rules
  def on(command : String, source : HookRule = nil, arguments : HookRule = nil, message : HookRule = nil, &hook : Hook)
    rule = HookRules.new(command, source, arguments, message)
    self.hooks.fetch(rule) { self.hooks[rule] = Array(Hook).new }
    self.hooks[rule] << hook
    self
  end

  # Handle one `Message`
  # It goes through the registred hooks, select the one to trigger.
  # Then, it execute every hooks associated, and send as parameters the current message and the regex match if possible
  # TODO: msg should NEVER be modified in the hook. (copy ? readonly ?)
  def handle(msg : Crirc::Protocol::Message)
    selected_hooks = self.hooks.select { |rule, hooks| rule.test(msg) }
    selected_hooks.each do |rule, hooks|
      hooks.each do |hook|
        message_to_handle = msg.message
        rule_message = rule.message
        match = if message && rule_message.is_a?(Regex)
          rule_message.match message_to_handle
        end
        hook.call msg, match
      end
    end
    self.hooks.fetch(msg.command) { Array(Hook).new }
    self
  end

  def handle(msg : String)
    handle Crirc::Protocol::Message.new(msg)
  end
end
