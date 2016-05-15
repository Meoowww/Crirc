module CrystalIrc
  class Client

    module Ping
      def ping(message = "0")
        socket.puts "PING #{message}"
      end

      def pong(message = "0")
        socket.puts "PONG #{message}"
      end
    end

  end
end
