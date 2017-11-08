require "./command"

module Crirc::Controller::Command::Chan
  include Crirc::Controller::Command::Command

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

  # Request to join the chan "chan", with the password "password".
  # The password may be ignored if not needed.
  def join(chan : Crirc::Protocol::Chan, password : String = "")
    puts "JOIN #{chan.name} #{password}"
  end

  # Request to leave the channel(s) "chans", with an optional part message "msg".
  def part(chans : Enumerable(Crirc::Protocol::Chan), msg : String? = nil)
    to_leave = format_list(chans)
    reason = ":#{msg}" if msg
    puts "PART #{to_leave} #{reason}"
  end

  # Request to leave the channel "chan", with an optional part message "msg".
  def part(chan : Crirc::Protocol::Chan, msg : String? = nil)
    reason = ":#{msg}" if msg
    puts "PART #{chan.name} #{reason}"
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

  # Request the names of the users in the given channel.
  # If no channel is given, requests the names of the users in every
  # known channel.
  def names(chan : Crirc::Protocol::Chan)
    puts "NAMES #{chan.name}"
  end

  # List the channels and their topics.
  # If the chans parameter is given, lists the status of the given chans.
  def list(chans : Enumerable(Crirc::Protocol::Chan?)?)
    target = format_list(chans) if chans
    puts "LIST #{target}"
  end

  # List the channels and their topics.
  # If the chan parameter is given, lists the status of the given chan.
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

  # Kick the user user from the channels chans.
  # The reason of the kick will be displayed if given as a parameter.
  def kick(chans : Enumerable(Crirc::Protocol::Chan), user : Crirc::Protocol::User, msg : String? = nil)
    chan = format_list(chans)
    reason = ":#{msg}" if msg
    puts "KICK #{chan} #{user.name} #{reason}"
  end

  # Kick the users users from the channel chan.
  # The reason of the kick will be displayed if given as a parameter.
  def kick(chan : Crirc::Protocol::Chan, users : Enumerable(Crirc::Protocol::User), msg : String? = nil)
    targets = format_list(users)
    reason = ":#{msg}" if msg
    puts "KICK #{chan.name} #{targets} #{reason}"
  end

  # Kick the user user from the channel chan.
  # The reason of the kick will be displayed if given as a parameter.
  def kick(chan : Crirc::Protocol::Chan, user : Crirc::Protocol::User, msg : String? = nil)
    reason = ":#{msg}" if msg
    puts "KICK #{chan.name} #{user.name} #{reason}"
  end
end
