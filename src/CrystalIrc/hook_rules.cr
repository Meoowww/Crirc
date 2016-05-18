require "./message"

module CrystalIrc

  class HookRules

    @source     : String | Regex | Nil
    @command    : String
    @arguments  : String | Regex | Nil

    getter source, command, arguments

    def initialize(@command, @source, @arguments)
    end

    def test(msg : CrystalIrc::Message)
      test_command(msg) && test_source(msg) && test_arguments(msg)
    end

    private def test_command(msg : CrystalIrc::Message)
      msg.command == command
    end

    private def test_source(msg : CrystalIrc::Message)
      return true if source.nil?
      source.is_a?(Regex) ? msg.source.to_s.match source as Regex : msg.source == source
    end

    private def test_arguments(msg : CrystalIrc::Message)
      return true if arguments.nil?
      arguments.is_a?(Regex) ? msg.arguments.to_s.match arguments as Regex : msg.arguments == arguments
    end
  end

end
