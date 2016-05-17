require "./client/*"

module CrystalIrc

  class Client
    include CrystalIrc::Client::Connect
    include CrystalIrc::Client::Ping
    include CrystalIrc::Client::Command
    include CrystalIrc::Client::Command::Chan
    include CrystalIrc::Client::Command::Talk
    include CrystalIrc::Client::Command::User

    @nick           : Nick
    @ip             : String
    @port           : UInt16
    @ssl            : Bool
    @socket         : IrcSocket?
    @user           : Nick?
    @realname       : Nick?
    @domain         : String?
    @pass           : String?
    @irc_server     : String?
    @read_timeout   : UInt16
    @write_timeout  : UInt16
    @keepalive      : Bool

    getter nick, ip, port, ssl, user, realname, domain, pass, irc_server, read_timeout, write_timeout, keepalive

    # default port is 6667 or 6697 if ssl is true
    def initialize(nick : String, @ip, @port = nil, @ssl = true, @user = nil, @realname = nil, @domain = nil, @pass = nil, @irc_server = nil,
      @read_timeout = 120_u16, @write_timeout = 5_u16, @keepalive = true)
      @nick = CrystalIrc::Client::Nick.new(nick)
      @port ||= (ssl ? 6697_u16 : 6667_u16)
      @user ||= @nick
      @realname ||= @nick
      @domain ||= "0"
      @irc_server ||= "*"
    end

    def gets(&block)
      yield socket.gets
    end

    # The client has to call connect() before using socket.
    # If the socket is not setup, it will rase a NoConnection error
    def socket : IrcSocket
      raise NoConnection.new "Socket is not set. Use connect(...) before." unless @socket
      @socket as IrcSocket
    end

    # Send a raw message to the socket. It should be a valid command
    # TODO: handle too large messages
    protected def send_raw(raw : String)
      socket.puts raw
    end
  end

end
