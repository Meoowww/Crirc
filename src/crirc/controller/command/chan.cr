require "../command"

# Defines the IRC commands that are related to chans (join, part, ...).
module Crirc::Controller::Command::Chan
  include Crirc::Controller::Command

  # Format the chans to join: #chan1,#chan2 (works with users by the same way)
  protected def format_list(chans : Enumerable(Crirc::Protocol::Target)) : String
    chans.map { |c| c.name }.to_set.join(",")
  end

  # Request to join the chan(s) "chans", with password(s) "passwords".
  # The passwords may be ignored if not needed.
  def join(chans : Enumerable(Crirc::Protocol::Chan), passwords : Enumerable(String) = [""])
    to_join = format_list(chans)
    passes = passwords.join(",")
    puts "JOIN #{to_join} #{passes}"
  end

  # Overloads the join function for 1 chan.
  def join(chan : Crirc::Protocol::Chan, password : String = "")
    join({chan}, {password})
  end

  # Request to leave the channel(s) "chans", with an optional part message "msg".
  def part(chans : Enumerable(Crirc::Protocol::Chan), msg : String? = nil)
    to_leave = format_list(chans)
    reason = ":#{msg}" if msg
    puts "PART #{to_leave} #{reason}"
  end

  # Overloads the part function for 1 chan.
  def part(chan : Crirc::Protocol::Chan, msg : String? = nil)
    part({chan}, msg)
  end

  # Request to change the mode of the given channel.
  # If the mode is to be applied to an user, precise it.
  def mode(chan : Crirc::Protocol::Chan, flags : String, user : Crirc::Protocol::User? = nil)
    target = user ? user.name : ""
    puts "MODE #{chan.name} #{flags} #{target}"
  end

  # Request to change the topic of the given channel.
  # If no topic is given, requests the topic of the given channel.
  def topic(chan : Crirc::Protocol::Chan, msg : String? = nil)
    topic = ":#{msg}" if msg
    puts "TOPIC #{chan.name} #{topic}"
  end

  # Request the names of the users in the given channel(s).
  # If no channel is given, requests the names of the users in every
  # known channel.
  def names(chans : Enumerable(Crirc::Protocol::Chan)?)
    target = format_list(chans) if chans
    puts "NAMES #{target}"
  end

  # Overloads the names function for 1 chan.
  def names(chan : Crirc::Protocol::Chan)
    names({chan})
  end

  # List the channels and their topics.
  # If the chans parameter is given, lists the status of the given chans.
  def list(chans : Enumerable(Crirc::Protocol::Chan?)?)
    target = format_list(chans) if chans
    puts "LIST #{target}"
  end

  # Overloads the list function for 1 chan.
  def list(chan : Crirc::Protocol::Chan)
    puts "LIST #{chan.name}"
  end

  # Invite the user "user" to the channel "chan".
  def invite(chan : Crirc::Protocol::Chan, user : Crirc::Protocol::User)
    puts "INVITE #{user.name} #{chan.name}"
  end

  # Kick the users users from the channels chans.
  # The reason of the kick will be displayed if given as a parameter.
  def kick(chans : Enumerable(Crirc::Protocol::Chan), users : Enumerable(Crirc::Protocol::User), msg : String? = nil)
    chan = format_list(chans)
    targets = format_list(users)
    reason = ":#{msg}" if msg
    puts "KICK #{chan} #{targets} #{reason}"
  end

  # Overloads the kick function for several chans, one user.
  def kick(chans : Enumerable(Crirc::Protocol::Chan), user : Crirc::Protocol::User, msg : String? = nil)
    kick(chans, {user}, msg)
  end

  # Overloads the kick function for one chan, several users.
  def kick(chan : Crirc::Protocol::Chan, users : Enumerable(Crirc::Protocol::User), msg : String? = nil)
    kick({chan}, users, msg)
  end

  # Overloads the kick function for one chan, one user.
  def kick(chan : Crirc::Protocol::Chan, user : Crirc::Protocol::User, msg : String? = nil)
    kick({chan}, {user}, msg)
  end
end
