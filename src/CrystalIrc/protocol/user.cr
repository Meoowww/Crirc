module CrystalIrc

  class User

    @name   : String
    @whois  : String?

    getter name
    property whois

    def initialize(@name, @whois = nil)
      raise InvalidUserName.new "The User name must not be empty" if @name.empty?
      raise InvalidUserName.new "The User name must contains at most 50 valid characters" if !@name.match(/\A(?!.{51,})(\#?([a-zA-Z])([a-zA-Z0-9_\-\[\]\\\`\^\{\}]+))\Z/)
    end
    def self.parse(source : String) : User
      m = source.match(/\A(?<name>[^!]+)!(?<whois>.+)\Z/)
      raise InvalidUserSource.new("The user \"#{source}\" is not valid") if m.nil?
      CrystalIrc::User.new(m["name"], m["whois"])
    end

  end

end
