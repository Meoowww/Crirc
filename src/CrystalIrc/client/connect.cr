module CrystalIrc
  class Client

    module Connect

      def connect : TCPSocket
        raise NotImplemented.new "SSL is not ready yet" if ssl
        @socket = TCPSocket.new ip, port
        send_login
        # handle answer
        socket
      end

      def send_login
        send_raw "PASS #{pass}" if pass
        send_raw "NICK #{nick}"
        send_raw "USER #{user} \"#{domain}\" \"#{irc_server}\" :#{realname}"
      end
    end

  end
end
