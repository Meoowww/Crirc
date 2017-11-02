require "./make_command"

module Crirc::Controller::Command::User
  # Request data about a given target
  make_command("whois", target : Crirc::Protocol::Target) do
    "WHOIS #{target.name}"
  end

  # Request data about the target who used to have the given name
  make_command("whowas", target : Crirc::Protocol::Target) do
    "WHOWAS #{target.name}"
  end

  # Request to set the mode of the user.
  # NOTE : only the user itself can change it
  # NOTE : it should also be possible to send empty flags to get the mode
  make_command("mode", target : Crirc::Protocol::Target, flags : String) do
    "MODE #{target.name} #{flags}"
  end
end
