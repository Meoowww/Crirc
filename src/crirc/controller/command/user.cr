require "../command"

# Defines the IRC commands related to the users (whois, mode).
module Crirc::Controller::Command::User
  include Crirc::Controller::Command

  # Request data about a given target
  def whois(target : Crirc::Protocol::Target)
    puts "WHOIS #{target.name}"
  end

  # Request data about the target who used to have the given name
  def whowas(target : Crirc::Protocol::Target)
    puts "WHOWAS #{target.name}"
  end

  # Request to set the mode of the user.
  # NOTE : only the user itself can change it
  # NOTE : it should also be possible to send empty flags to get the mode
  def mode(target : Crirc::Protocol::Target, flags : String)
    puts "MODE #{target.name} #{flags}"
  end
end
