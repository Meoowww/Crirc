require "../command"

# Defines the IRC commands related to communicating between "humans".
module Crirc::Controller::Command::Talk
  include Crirc::Controller::Command

  # Send a notice to a target
  def notice(target : Crirc::Protocol::Target, msg : String)
    puts "NOTICE #{target.name} :#{msg}"
  end

  # Send a message to a chan or an user
  def privmsg(target : Crirc::Protocol::Target, msg : String)
    puts "PRIVMSG #{target.name} :#{msg}"
  end
end
