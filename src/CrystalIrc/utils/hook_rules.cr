module CrystalIrc
  module Handler
    # The `HookRules` define a set of rules.
    # Theses rules can test an event (message) to "match" with.
    class HookRules
      @source : String | Regex | Nil
      @command : String | Regex
      @arguments : String | Regex | Nil
      @message : String | Regex | Nil

      getter source, command, arguments, message

      # - "command" is by default "PRIVMSG", and must be a UPPERCASE irc command (JOIN, PRIVMSG, ...)
      # - "source" is optional. It represents the sender.
      # - "arguments" is optional. It represents the parameters (without the last argument if prefixed with ":", like in JOIN).
      # - "message" is optional. It represents the last argument when prefixed with ":".
      def initialize(@command = "PRIVMSG", @source = nil, @arguments = nil, @message = nil)
      end

      def test(msg : CrystalIrc::Message)
        test_command(msg) && test_source(msg) && test_arguments(msg) && test_message(msg)
      end

      private def test_command(msg : CrystalIrc::Message)
        command.is_a?(Regex) ? msg.command.to_s.match command.as(Regex) : msg.command == command
      end

      {% for ft in ["source", "arguments", "message"] %}
      private def {{ ("test_" + ft).id }}(msg : CrystalIrc::Message)
        return true if {{ ft.id }}.nil?
        return false if msg.{{ ft.id }}.nil?
        {{ ft.id }}.is_a?(Regex) ? msg.{{ ft.id }}.to_s.match {{ ft.id }}.as(Regex) : msg.{{ ft.id }} == {{ ft.id }}
      end
      {% end %}
    end
  end
end
