require "../has_socket"

module CrystalIrc
  class Server
    class Client < CrystalIrc::HasSocket

      @socket : TCPSocket

      def initialize(@socket)
      end

      def close; @socket.close; end
      def closed?; @socket.closed?; end
      def gets : String; @socket.gets; end
      def gets; yield @socket.gets; end
      def puts(e); @socket.puts(e); end

    end
  end
end
