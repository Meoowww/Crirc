module CrystalIrc
  class Server
    class Client

      @socket : TCPSocket

      def initialize(@socket)
      end

      delegate "close", @socket
      delegate "closed?", @socket
      delegate "gets", @socket
      delegate "puts", @socket

    end
  end
end
