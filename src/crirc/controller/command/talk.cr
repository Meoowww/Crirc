require "./make_command"

module Crirc::Controller::Command::Talk
  include Crirc::Controller::Command::Make
  # Send a notice to a target
  make_command("notice", target : Crirc::Protocol::Target, msg : String) do
    "NOTICE #{target.name} :#{msg}"
  end

  # Send a message to a chan or an user
  make_command("privmsg", target : Crirc::Protocol::Target, msg : String) do
    "PRIVMSG #{target.name} :#{msg}"
  end
end
