module CrystalIrc

  class Server

    @host   : String
    @port   : UInt16
    @socket : TCPServer
    @ssl    : Bool

    getter host, port, socket

    def initialize(@host = "127.0.0.1", @port = 6668_16, @ssl = true)
      @socket = TCPServer.new(@host, @port)
    end

    def self.open(host = "127.0.0.1", port = 6668_u16, ssl = true)
      s = new host, port, ssl
      begin
        yield s
      ensure
        s.close
      end
    end

    def accept
      @socket.accept { |s| yield s }
    end

    delegate "close", socket
  end

end
