module CrystalIrc
  class Client

    module Connect
      extend self
      # domain and irc_server are not used
      def connect
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
