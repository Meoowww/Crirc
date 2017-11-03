require "./command"

module Crirc::Controller::Command::Ping
  include Crirc::Controller::Command::Command
  # Send a ping to check if the other end is alive
  def ping(msg : String = "0")
    puts "PING :#{msg}"
  end

  # Answer to a ping command with a pong
  def pong(msg : String = "0")
    puts "PONG :#{msg}"
  end
end
