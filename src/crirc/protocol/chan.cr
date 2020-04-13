require "./target"

# Represents an IRC channel.
class Crirc::Protocol::Chan < Crirc::Protocol::Target
  class Motd
    getter message : String
    getter user : String
    getter timestamp : Int64

    def initialize(@message, @user)
      @timestamp = Time.utc.to_unix
    end

    def set_motd(@message, @user)
      @timestamp = Time.utc.to_unix
    end
  end

  getter name : String
  property modes : String
  property motd : Motd

  def initialize(@name)
    raise ParsingError.new "The Chan name (#{@name}) must not be empty" if @name.empty?
    raise ParsingError.new "The Chan name (#{@name}) must begin with a \"#\"" if !@name.match(/\A\#.+\Z/)
    raise ParsingError.new "The Chan name (#{@name}) must contains at most 63 valid characters" if !@name.match(/\A(?!.{51,})(\#\#?([^[:space:],]+))\Z/)
    @modes = ""
    @motd = Motd.new("", "")
  end

  class ParsingError < Exception; end
end
