require "./target"

module CrystalIrc
  # Representation of an IRC client.
  #
  # It has a name (or nick), id (id@...) and an optionaly a whois.
  #
  # It does not represent a controllable client (only the class `Client` does).
  # TODO: checkout the masks
  class User < Target
    @nick : String
    @id : String
    @whois : String?

    getter nick, id, whois

    # TODO: fix the parser
    def initialize(@nick, id = nil, @whois = nil)
      raise ParsingError.new @nick, "user name must not be empty" if @nick.empty?
      raise ParsingError.new @nick, "user name must contains at most 50 valid characters" if !@nick.match(/\A(?!.{51,})(\#?([a-zA-Z])([a-zA-Z0-9_\|\-\[\]\\\`\^\{\}]+))\Z/)
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
