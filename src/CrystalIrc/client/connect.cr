require "openssl"

module CrystalIrc
  class Client
    alias IrcSocket = (TCPSocket | OpenSSL::SSL::Socket)

    module Connect

      def connect : IrcSocket
        tmp_socket = TCPSocket.new ip, port
        tmp_socket.read_timeout  = read_timeout
        tmp_socket.write_timeout = write_timeout
        tmp_socket.keepalive     = keepalive
        @socket = tmp_socket
        @socket = OpenSSL::SSL::Socket.new(tmp_socket) if ssl
        send_login
        # handle answer
        socket
      end

      # send the connecttion sequence (PASS, NICK, USER). The password
      # is optionnal.
      # It does not handle the errors.
      def send_login
        send_raw "PASS #{pass}" if pass
        send_raw "NICK #{nick}"
        send_raw "USER #{user} \"#{domain}\" \"#{irc_server}\" :#{realname}"
      end
    end

  end
end
