module CrystalIrc::Command::Ping
  def ping(message = "0")
    send_raw "PING :#{message}"
  end

  def pong(message = "0")
    send_raw (message.nil? || message.empty?) ? "PONG" : "PONG :#{message}"
  end
end
