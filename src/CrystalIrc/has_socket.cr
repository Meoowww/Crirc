$verbose : Bool?

module CrystalIrc
  abstract class HasSocket
    abstract def socket : IrcSocket

    # Send a raw message to the socket. It should be a valid command
    # TODO: handle too large messages for IRC
    def send_raw(raw : String) : HasSocket
      begin
        socket.puts raw
        STDERR.puts "[#{Time.now}] #{socket}.send_raw(#{raw.inspect}): ok" if $verbose == true
      rescue e
        STDERR.puts "[#{Time.now}] #{socket}.send_raw(#{raw.inspect}): #{e}" if $verbose == true
        raise e
      end
      self
    end

    def answer_raw(from : String, raw : String)
      send_raw(":#{from} #{raw}")
    end

    def close
      socket.close
    end

    def closed?
      socket.closed?
    end

    protected def puts(e)
      socket.puts(e)
    end

    def gets
      yield socket.gets
    end

    def gets
      r = socket.gets
      STDERR.puts "[#{Time.now}] #{socket}.gets() => #{r.inspect}: ok" if $verbose == true
      r
    end
  end
end
