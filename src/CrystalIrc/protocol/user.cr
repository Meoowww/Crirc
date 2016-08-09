require "./target"

module CrystalIrc
  # Represent an user, with a name, and an optional whois
  class User < Target
    @nick : String
    @id : String
    @whois : String?

    getter nick, id, whois

    def initialize(@nick, id = nil, @whois = nil)
      raise ParsingError.new @nick, "user name must not be empty" if @nick.empty?
      raise ParsingError.new @nick, "user name must contains at most 50 valid characters" if !@nick.match(/\A(?!.{51,})(\#?([a-zA-Z])([a-zA-Z0-9_\-\[\]\\\`\^\{\}]+))\Z/)
      @id = id || @nick
    end

    def self.parse(source : String) : User
      m = source.match(/\A:?(?<name>[^!]+)!(?<id>.+)@(?<whois>.+)\Z/)
      raise ParsingError.new source, "invalid user" if m.nil?
      CrystalIrc::User.new(m["name"], m["id"], m["whois"])
    end

    def name : String
      @nick
    end
  end
end
