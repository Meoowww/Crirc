require "./has_socket"
require "./command/*"

abstract class CrystalIrc::IrcSender < CrystalIrc::HasSocket
  include CrystalIrc::Command::Ping
  include CrystalIrc::Command::Chan
  include CrystalIrc::Command::Talk
  include CrystalIrc::Command::User

  abstract def from : String

  def answer_raw(raw : String, output : IO? = nil) : IrcSender
    send_raw ":#{from} #{raw}", output
  end
end
