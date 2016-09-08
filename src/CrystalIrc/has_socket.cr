abstract class CrystalIrc::HasSocket
  abstract def socket : IrcSocket

  # Send a raw message to the socket. It should be a valid command
  # TODO: handle too large messages for IRC
  def send_raw(raw : String, output : IO? = nil) : HasSocket
    begin
      socket.puts raw
      output.puts raw if !output.nil?
      STDERR.puts "[#{Time.now}] #{raw}" if ::VERBOSE == true
    rescue e
      STDERR.puts "#{e} -> [#{Time.now}] #{raw.inspect}" if ::VERBOSE == true
      raise e
    end
    self
  end

  def answer_raw(from : String, raw : String, output : IO? = nil)
    send_raw(":#{from} #{raw}", output)
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
    STDERR.puts "[#{Time.now}] #{socket}.gets() => #{r.inspect}: ok" if ::VERBOSE == true
    r
  end
end
