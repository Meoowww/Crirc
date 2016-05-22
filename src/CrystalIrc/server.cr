module CrystalIrc

  class Server

    @listen : String
    @port   : UInt16
    @socket : TCPServer
    @ssl    : Bool

    getter listen, port, socket

    def initialize(@listen, @port, @ssl)
      @socket = TCPServer.new(@listen, @port)
    end

  end

end
