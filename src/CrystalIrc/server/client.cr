require "../irc_sender"

module CrystalIrc
  class Server
    # Represent a client, from the point of view of the server.
    class Client < CrystalIrc::IrcSender
      @socket : TCPSocket

      def initialize(@socket)
      end

      protected def socket
        @socket
      end

      def from
        "0" #  TODO: find the client through the Server.users
      end
    end
  end
end
