require "./client/*"

module CrystalIrc

  class Client
    include CrystalIrc::Client::Connect
    include CrystalIrc::Client::Ping
    include CrystalIrc::Client::Command::Chan
    include CrystalIrc::Client::Command::User
    include CrystalIrc::Client::Command::Talk

    @nick : String
    @ip   : String
    @port : UInt16
    @ssl  : Bool

    def initialize(@nick, @ip, @port, @ssl = true)
    end
  end

end
