require "./client/*"

module CrystalIrc

  class Client

    @nick   : String
    @ip     : String
    @port   : UInt16
    @ssl    : Bool
    @socket : TCPSocket?

    getter nick, ip, port, ssl, socket

    def initialize(@nick, @ip, @port, @ssl = true)
    end

    def connect
      @socket = CrystalIrc::Client::Connect.start(nick: @nick, ip: @ip, port: @port, ssl: @ssl)
    end

    def send(to, message)
      raise NoConnection.new "Socket is not set. Use connect(...) before." unless @socket
      socket.puts("#{to} #{message}")
    end
  end

end
