require "./irc_sender"
module CrystalIrc
  class Client < CrystalIrc::IrcSender
  end
end

require "./client/*"

module CrystalIrc
  class Client

    include CrystalIrc::Client::Connect
    include CrystalIrc::Handler

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
    def initialize(nick : String, @ip, port = nil as UInt16?, @ssl = true, @user = nil, @realname = nil, @domain = nil, @pass = nil, @irc_server = nil,
      @read_timeout = 120_u16, @write_timeout = 5_u16, @keepalive = true)
      @nick = CrystalIrc::Nick.new(nick)
      @port = port || (ssl ? 6697_u16 : 6667_u16)
      @user ||= @nick
      @realname ||= @nick
      @domain ||= "0"
      @irc_server ||= "*"
      super()
    end

    # The client has to call connect() before using socket.
    # If the socket is not setup, it will rase a NoConnection error
    protected def socket : IrcSocket
      raise NoConnection.new "Socket is not set. Use connect(...) before." unless @socket
      @socket as IrcSocket
    end

  end
end
