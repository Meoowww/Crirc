require "./make_command"

module Crirc::Controller::Command::Chan
  include Crirc::Controller::Command::Make

  # Format the chans to join: #chan1,#chan2 (works with users by the same way)
  protected def format_list(chans : Enumerable(CrystalIrc::Target)) : String
    chans.map { |c| c.name }.to_set.join(",")
  end

  # Request to join the chan(s) chans, with password(s) passwords.
  # The passwords may be ignored if not needed.
  make_command("join", chans : Enumerable(CrystalIrc::Chan), passwords : Enumerable(String) = [""]) do
    to_join = format_list(chans)
    passes = passwords.uniq.join(",")
    "JOIN #{to_join} #{passes}"
  end

  # Request to leave the channel(s) chans, with an optional part message msg.
  make_command("part", chans : Enumerable(CrystalIrc::Chan), msg : String? = nil) do
    to_leave = format_list(chans)
    reason = ":#{msg}" if msg
    "PART #{to_leave} #{reason}"
  end

  # Request to change the mode of the given channel.
  # If the mode is to be applied to an user, precise it.
  make_command("mode", chan : CrystalIrc::Chan, flags : String, user : CrystalIrc::User? = nil) do
    target = user ? user.name : ""
    "MODE #{chan.name} #{flags} #{target}"
  end

  # Request to change the topic of the given channel.
  # If no topic is given, requests the topic of the given channel.
  make_command("topic", chan : CrystalIrc::Chan, topic : String) do
    "TOPIC #{chan.name} :#{topic}"
  end

  # Request the names of the users in the given channel(s).
  # If no channel is given, requests the names of the users in every
  # known channel.
  make_command("names", chans : Enumerable(CrystalIrc::Chan)) do
    target = format_list(chans)
    "NAMES #{target}"
  end

  # List the channels and their topics.
  # If the chans parameter is given, lists the status of the given chans.
  make_command("list", chans : Enumerable(CrystalIrc::Chan)) do
    target = format_list(chans)
    "LIST #{target}"
  end

  # Invite the user "user" to the channel "chan".
  make_command("invite", chan : CrystalIrc::Chan, user : CrystalIrc::User) do
    "INVITE #{user.name} #{chan.name}"
  end

  # Kick the user(s) users from the channel(s) chans.
  # The reason of the kick will be displayed if given as a parameter.
  make_command("kick", chans : Enumerable(CrystalIrc::Chan), users : Enumerable(CrystalIrc::User), msg : String? = nil) do
    chan = format_list(chans)
    targets = format_list(users)
    reason = ":#{msg}" if msg
    "KICK #{chan} #{targets} #{reason}"
  end
end
