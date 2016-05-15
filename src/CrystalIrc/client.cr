require "./client/*"

module CrystalIrc

  class Client
    include CrystalIrc::Client::Connect
    include CrystalIrc::Client::Ping
    include CrystalIrc::Client::Command
    include CrystalIrc::Client::Command::Chan
    include CrystalIrc::Client::Command::Talk
    include CrystalIrc::Client::Command::User

    @nick       : String
    @ip         : String
    @port       : UInt16
    @ssl        : Bool
    @socket     : TCPSocket?
    @user       : String?
    @realname   : String?
    @pass       : String?
    @irc_server : String?

    getter nick, ip, port, ssl, socket, user, realname, pass, irc_server

    def initialize(@nick, @ip, @port, @ssl = true)
    end

    def send_raw(raw : String)
      raise NoConnection.new "Socket is not set. Use connect(...) before." unless socket
      socket.puts raw
    end

    def connect
      connect
    end
  end

end
