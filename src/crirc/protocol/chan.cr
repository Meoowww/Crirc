require "./target"

# Represent an IRC channel.
class Crirc::Protocol::Chan < Crirc::Protocol::Target
  class Motd
    getter message : String
    getter user : String
    getter timestamp : Int64

    def initialize(@message, @user)
      @timestamp = Time.now.epoch
    end

    def set_motd(@message, @user)
      @timestamp = Time.now.epoch
    end
  end

  getter name : String
  property modes : String
  property motd : Motd

  def initialize(@name)
    raise ParsingError.new @name, "The Chan name must not be empty" if @name.empty?
    raise ParsingError.new @name, "The Chan name must begin with a \"#\"" if !@name.match(/\A\#.+\Z/)
    raise ParsingError.new @name, "The Chan name must contains at most 63 valid characters" if !@name.match(/\A(?!.{51,})(\#\#?([^[:space:],]+))\Z/)
    @modes = ""
    @modt.new("", "")
  end

  class ParsingError < Exception; end
end
