$verbose : Bool?

module CrystalIrc
  abstract class HasSocket

    abstract def socket : IrcSocket

    # Send a raw message to the socket. It should be a valid command
    # TODO: handle too large messages for IRC
    def send_raw(raw : String)
      begin
        socket.puts raw
        STDERR.puts "#{socket}.send_raw(#{raw.inspect}): ok" if $verbose == true
      rescue e
        STDERR.puts "#{socket}.send_raw(#{raw.inspect}): #{e}" if $verbose == true
        raise e
      end
    end

    def close; socket.close; end
    def closed?; socket.closed?; end
    protected def puts(e); socket.puts(e); end
    def gets; yield socket.gets; end
    def gets
      r = socket.gets
      STDERR.puts "#{socket}.gets() => #{r.inspect}: ok" if $verbose == true
      r
    end
  end
end
