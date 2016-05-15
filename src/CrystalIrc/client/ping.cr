module CrystalIrc
  class Client

    module Ping
      def ping(message = "0")
        send_raw "PING #{message}"
      end

      def pong(message = "0")
        send_raw "PONG #{message}"
      end
    end

  end
end
