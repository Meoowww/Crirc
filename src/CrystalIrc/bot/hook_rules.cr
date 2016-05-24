module CrystalIrc
  class Bot

    class HookRules

      @source     : String | Regex | Nil
      @command    : String | Regex
      @arguments  : String | Regex | Nil
      @message    : String | Regex | Nil

      getter source, command, arguments, message

      # @param command is by default "PRIVMSG", and must be a UPPERCASE irc command (JOIN, PRIVMSG, ...)
      # @param source is optional. It represents the sender.
      # @param arguments is optional. It represents the parameters (without the last argument if prefixed with ":", like in JOIN).
      # @param source is optional. It represents the last argument when prefixed with ":".
      def initialize(@command = "PRIVMSG", @source = nil, @arguments = nil, @message = nil)
      end

      def test(msg : CrystalIrc::Message)
        test_command(msg) && test_source(msg) && test_arguments(msg) && test_message(msg)
      end

      private def test_command(msg : CrystalIrc::Message)
        command.is_a?(Regex) ? msg.command.to_s.match command as Regex : msg.command == command
      end

      # TODO: macro de defines theses methods
      private def test_source(msg : CrystalIrc::Message)
        return true if source.nil?
        return false if msg.source.nil?
        source.is_a?(Regex) ? msg.source.to_s.match source as Regex : msg.source == source
      end

      private def test_arguments(msg : CrystalIrc::Message)
        return true if arguments.nil?
        return false if msg.arguments.nil?
        arguments.is_a?(Regex) ? msg.arguments_raw.to_s.match arguments as Regex : msg.arguments_raw == arguments
      end

      private def test_message(msg : CrystalIrc::Message)
        return true if message.nil?
        return false if msg.message.nil?
        message.is_a?(Regex) ? msg.message.to_s.match message as Regex : msg.message == message
      end
    end

  end
end
