require "./message"

module CrystalIrc

  class HookRules

    @source     : String | Regex | Nil
    @command    : String
    @arguments  : String | Regex | Nil
    @message    : String | Regex | Nil

    getter source, command, arguments, message

    def initialize(@command, @source, @arguments, @message)
    end

    def test(msg : CrystalIrc::Message)
      test_command(msg) && test_source(msg) && test_arguments(msg) && test_message(msg)
    end

    private def test_command(msg : CrystalIrc::Message)
      msg.command == command
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
      arguments.is_a?(Regex) ? msg.arguments.to_s.match arguments as Regex : msg.arguments == arguments
    end

    private def test_message(msg : CrystalIrc::Message)
      return true if message.nil?
      return false if msg.message.nil?
      message.is_a?(Regex) ? msg.message.to_s.match message as Regex : msg.message == message
    end
  end

end
