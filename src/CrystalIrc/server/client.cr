require "../irc_sender"

module CrystalIrc
  class Server
    class Client < CrystalIrc::IrcSender

      @socket : TCPSocket

      def initialize(@socket)
      end

      protected def socket
        @socket
      end

    end
  end
end
