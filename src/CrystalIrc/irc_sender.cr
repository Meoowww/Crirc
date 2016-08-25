require "./has_socket"
require "./command/*"

abstract class CrystalIrc::IrcSender < CrystalIrc::HasSocket
  include CrystalIrc::Command::Ping
  include CrystalIrc::Command::Chan
  include CrystalIrc::Command::Talk
  include CrystalIrc::Command::User

  abstract def from : String

  def answer_raw(raw : String) : IrcSender
    send_raw(":#{from} #{raw}")
  end
end
