module CrystalIrc
  class Client

    module Ping
      def ping(socket : TCPSocket, message = "0")
        socket.puts "PING #{message}"
      end

      def pong(socket : TCPSocket, message = "0")
        socket.puts "PONG #{message}"
      end
    end

  end
end
