require "./make_command"

module Crirc::Controller::Command::Ping
  include Crirc::Controller::Command::Make
  # Send a ping to check if the other end is alive
  make_command("ping", msg = "0") do
    "PING :#{msg}"
  end

  # Answer to a ping command with a pong
  make_command("pong", msg = "0") do
    "PONG :#{msg}"
  end
end
