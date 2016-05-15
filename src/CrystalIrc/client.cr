require "./client/*"

module CrystalIrc

  class Client
    include CrystalIrc::Client::Connect

    @nick : String
    @ip   : String
    @port : UInt16
    @ssl  : Bool

    def initialize(@nick, @ip, @port, @ssl = true)
    end
  end

end
