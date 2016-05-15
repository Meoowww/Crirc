module CrystalIrc
  class Client

    module Connect
      def connect(nick : String, ip : String, port : UInt16, ssl : Bool, user : String?, ident : String?, domain : String?, irc_server : String?) : TCPSocket?
        raise NotImplemented.new "SSL is not ready yet" if ssl
        socket = TCPSocket.new ip, port
        user ||= nick
        ident ||= nick
        domain ||= "localhost"
        irc_server ||= "irc_server"
        socket.puts "NICK #{nick}"
        socket.puts "USER #{user} \"#{domain}\" \"#{irc_server}\" :#{ident}"
        # handle answer
        socket
      end
    end

  end
end
