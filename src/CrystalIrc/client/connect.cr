require "openssl"

module CrystalIrc::Client::Connect
  # Connect the client to the server.
  #
  # It does send the login informations.
  def connect : Client
    tmp_socket = TCPSocket.new ip, port
    tmp_socket.read_timeout = read_timeout
    tmp_socket.write_timeout = write_timeout
    tmp_socket.keepalive = keepalive
    @socket = tmp_socket
    @socket = OpenSSL::SSL::Socket::Client.new(tmp_socket) if ssl
    send_login
    self
  end

  def connect : Client
    yield connect()
    close()
    self
  end

  def on_ready(&b) : Client
    self.on("001") { b.call }
    self
  end

  # Sends the connecttion sequence (PASS, NICK, USER).
  # The password is sent only if specified.
  # It does not handle the errors (it is done in `binding.cr`).
  def send_login : Client
    send_raw "PASS #{pass}" if pass
    send_raw "NICK #{nick.to_s}"
    send_raw "USER #{user.to_s} \"#{domain}\" \"#{irc_server}\" :#{realname.to_s}"
    self
  end
end
