require "./command"

module Crirc::Controller::Command::Chan
  include Crirc::Controller::Command::Command

  # Format the chans to join: #chan1,#chan2 (works with users by the same way)
  protected def format_list(chans : Enumerable(Crirc::Protocol::Target)) : String
    chans.map { |c| c.name }.to_set.join(",")
  end

  # Request to join the chan(s) chans, with password(s) passwords.
  # The passwords may be ignored if not needed.
  def join(chans : Enumerable(Crirc::Protocol::Chan), passwords : Enumerable(String) = [""])
    to_join = format_list(chans)
    passes = passwords.join(",")
    puts "JOIN #{to_join} #{passes}"
  end

  # Request to leave the channel(s) chans, with an optional part message msg.
  def part(chans : Enumerable(Crirc::Protocol::Chan), msg : String? = nil)
    to_leave = format_list(chans)
    reason = ":#{msg}" if msg
    puts "PART #{to_leave} #{reason}"
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

  # List the channels and their topics.
  # If the chans parameter is given, lists the status of the given chans.
  def list(chans : Enumerable(Crirc::Protocol::Chan?)?)
    target = format_list(chans) if chans
    puts "LIST #{target}"
  end

  # Invite the user "user" to the channel "chan".
  def invite(chan : Crirc::Protocol::Chan, user : Crirc::Protocol::User)
    puts "INVITE #{user.name} #{chan.name}"
  end

  # Kick the user(s) users from the channel(s) chans.
  # The reason of the kick will be displayed if given as a parameter.
  def kick(chans : Enumerable(Crirc::Protocol::Chan), users : Enumerable(Crirc::Protocol::User), msg : String? = nil)
    chan = format_list(chans)
    targets = format_list(users)
    reason = ":#{msg}" if msg
    puts "KICK #{chan} #{targets} #{reason}"
  end
end
