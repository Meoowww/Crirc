require "./target"
require "./user"

module CrystalIrc
  # Represent a channel, with a name, ...
  class Chan < Target
    @name : String
    @users : Array(User)

    getter name, users
    setter users

    def initialize(@name)
      raise ParsingError.new @name, "The Chan name must not be empty" if @name.empty?
      raise ParsingError.new @name, "The Chan name must begin with a \"#\"" if !@name.match(/\A\#.+\Z/)
      raise ParsingError.new @name, "The Chan name must contains at most 63 valid characters" if !@name.match(/\A(?!.{51,})(\#\#?([^[:space:],]+))\Z/)
      @users = [] of User
    end

    # Search an `User` by name (nick).
    def user(user_name : String) : User
      user = self.users.bsearch { |e| e.name == user_name }
      raise IrcError.new("Cannot find the user \"#{user_name}\" in \"#{@name}\"") if user.nil?
      user.as(User)
    end
  end
end
