module CrystalIrc
  class Client

    module Connect
      # domain and irc_server are not used
      def connect(nick : String, ip : String, port : UInt16, ssl : Bool, user : String?, realname : String?, pass : String?, domain : String?, irc_server : String?) : TCPSocket?
        raise NotImplemented.new "SSL is not ready yet" if ssl
        socket = TCPSocket.new ip, port
        send_login(socket: socket, nick: nick, user: user || nick, realname: realname || nick, pass: pass)
        # handle answer
        socket
      end

      def send_login(socket : TCPSocket, nick : String, user : String, realname : String?, pass : String?, domain = "0", irc_server = "*")
        socket.puts "PASS #{pass}" if pass
        socket.puts "NICK #{nick}"
        socket.puts "USER #{user} \"#{domain}\" \"#{irc_server}\" :#{realname}"
      end
    end

  end
end
