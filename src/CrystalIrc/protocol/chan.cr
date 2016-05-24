require "./user"

module CrystalIrc

  class Chan < User
    def initialize(@name)
      raise InvalidChanName.new "The Chan name must not be empty" if @name.empty?
      raise InvalidChanName.new "The Chan name must begin with a \"#\"" if !@name.match(/\A\#.+\Z/)
      raise InvalidChanName.new "The Chan name must contains at most 63 valid characters" if !@name.match(/\A(?!.{51,})(\#\#?([^[:space:],]+))\Z/)
    end
  end

end
