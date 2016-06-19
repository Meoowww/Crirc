module CrystalIrc
  abstract class HasSocket

    abstract def socket : IrcSocket
    # Send a raw message to the socket. It should be a valid command
    # TODO: handle too large messages for IRC
    protected def send_raw(raw : String)
      socket.puts raw
    end

    def close; socket.close; end
    def closed?; socket.closed?; end
    def puts(e); socket.puts(e); end
    def gets; yield socket.gets; end
    def gets; socket.gets; end
  end
end
