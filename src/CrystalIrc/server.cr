require "./server/*"

module CrystalIrc

  class Server

    @host   : String
    @port   : UInt16
    @socket : TCPServer
    @ssl    : Bool
    @chans  : Hash(String, Chan)
    @users  : Hash(String, User)

    getter host, port, socket, chans, users

    # TODO: add ssl socket
    def initialize(@host = "127.0.0.1", @port = 6697_16, @ssl = true)
      @socket = TCPServer.new(@host, @port)
      @chans = Hash(String, Chan).new
      @users = Hash(String, User).new
    end

    def self.open(host = "127.0.0.1", port = 6697_u16, ssl = true)
      s = new host, port, ssl
      begin
        yield s
      ensure
        s.close
      end
    end

    def accept
      @socket.accept { |s| yield CrystalIrc::Server::Client.new s }
    end

    delegate "close", socket
    delegate "closed?", socket
  end

end
