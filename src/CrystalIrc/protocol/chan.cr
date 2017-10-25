require "./target"
require "./user"

# Represent an IRC channel.
#
# It has a name and a list of user.
# TODO: checkout the masks
class CrystalIrc::Chan < CrystalIrc::Target
  class CrystalIrc::Chan::Motd
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
  property users : Array(User)
  property modes : String # TODO : for now chan modes are purely decorative
  property motd : CrystalIrc::Chan::Motd?

  getter name, users, motd, modes
  setter users, modes, motd

  def initialize(@name)
    raise ParsingError.new @name, "The Chan name must not be empty" if @name.empty?
    raise ParsingError.new @name, "The Chan name must begin with a \"#\"" if !@name.match(/\A\#.+\Z/)
    raise ParsingError.new @name, "The Chan name must contains at most 63 valid characters" if !@name.match(/\A(?!.{51,})(\#\#?([^[:space:],]+))\Z/)
    @users = [] of User
    @modes = ""
  end

  # Search an `User` by name (nick).
  def user(user_name : String) : User
    user = self.users.select { |e| e.name == user_name }.first?
    raise IrcError.new("Cannot find the user \"#{user_name}\" in \"#{@name}\"") if user.nil?
    user.as(User)
  end

  def has?(user_name : String) : Bool
    !!user(user_name) rescue false
  end

  def has?(user : User) : Bool
    has?(user.name)
  end
end
