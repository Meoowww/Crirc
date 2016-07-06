module CrystalIrc
  # Represent an user, with a name, and an optional whois
  class User
    @name : String
    @whois : String?

    getter name
    property whois

    def initialize(@name, @whois = nil)
      raise ParsingError.new @name, "user name must not be empty" if @name.empty?
      raise ParsingError.new @name, "user name must contains at most 50 valid characters" if !@name.match(/\A(?!.{51,})(\#?([a-zA-Z])([a-zA-Z0-9_\-\[\]\\\`\^\{\}]+))\Z/)
    end

    def self.parse(source : String) : User
      m = source.match(/\A(?<name>[^!]+)!(?<whois>.+)\Z/)
      raise ParsingError.new source, "invalid user" if m.nil?
      CrystalIrc::User.new(m["name"], m["whois"])
    end
  end
end
