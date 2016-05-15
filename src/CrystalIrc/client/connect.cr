module CrystalIrc
  class Client

    module Connect
      def connect(nick : String, ip : String, port : UInt16, ssl : Bool) : TCPSocket?
        raise NotImplemented.new "SSL is not ready yet" if ssl
        socket = TCPSocket.new ip, port
        # connect
        socket
      end
    end

  end
end
