require "./has_socket"
require "./command/*"

module CrystalIrc
  abstract class IrcSender < HasSocket
    include CrystalIrc::Command::Ping
    include CrystalIrc::Command::Chan
    include CrystalIrc::Command::Talk
    include CrystalIrc::Command::User
  end
end
