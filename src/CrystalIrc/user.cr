module CrystalIrc

  class User

    @name   : String

    getter name

    def initialize(@name)
      raise InvalidUserName.new "The User name must not be empty" if @name.empty?
      raise InvalidUserName.new "The User name must contains at most 63 valid characters" if !@name.match(/\A(?!.{51,})(\#?([a-zA-Z])([a-zA-Z0-9_\-\[\]\\\`\^\{\}]+))\Z/)
    end

  end

end
