require "./user"

module CrystalIrc
  # Represent a channel, with a name, ...
  class Chan < User
    def initialize(@name)
      raise ParsingError.new @name, "The Chan name must not be empty" if @name.empty?
      raise ParsingError.new @name, "The Chan name must begin with a \"#\"" if !@name.match(/\A\#.+\Z/)
      raise ParsingError.new @name, "The Chan name must contains at most 63 valid characters" if !@name.match(/\A(?!.{51,})(\#\#?([^[:space:],]+))\Z/)
    end
  end
end
