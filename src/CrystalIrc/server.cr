module CrystalIrc

  class Server

    @host   : String
    @port   : UInt16
    @socket : TCPServer
    @ssl    : Bool

    getter host, port, socket

    # TODO: add ssl socket
    def initialize(@host = "127.0.0.1", @port = 6697_16, @ssl = true)
      @socket = TCPServer.new(@host, @port)
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
      @socket.accept { |s| yield s }
    end

    delegate "close", socket
  end

end
