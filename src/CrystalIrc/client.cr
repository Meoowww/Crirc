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

    @nick : Nick
    @ip : String
    @port : UInt16
    @ssl : Bool
    @socket : IrcSocket?
    @user : Nick?
    @realname : Nick?
    @domain : String?
    @pass : String?
    @irc_server : String?
    @read_timeout : UInt16
    @write_timeout : UInt16
    @keepalive : Bool
    @chans : Array(Chan)

    getter nick, ip, port, ssl, user, realname, domain, pass, irc_server, read_timeout, write_timeout, keepalive, chans

    # default port is 6667 or 6697 if ssl is true
    def initialize(nick : String, @ip, port = nil.as(UInt16?), @ssl = true, @user = nil, @realname = nil, @domain = nil, @pass = nil, @irc_server = nil,
                   @read_timeout = 120_u16, @write_timeout = 5_u16, @keepalive = true)
      @nick = CrystalIrc::Nick.new(nick)
      @port = port || (ssl ? 6697_u16 : 6667_u16)
      @user ||= @nick
      @realname ||= @nick
      @domain ||= "0"
      @irc_server ||= "*"
      @chans = [] of Chan
      super()
      CrystalIrc::Client::Binding.attach(self)
    end

    # The client has to call connect() before using socket.
    # If the socket is not setup, it will rase a NoConnection error
    protected def socket : IrcSocket
      raise NetworkError.new "Socket is not set. Use connect(...) before." unless @socket
      @socket.as(IrcSocket)
    end

    def from : String
      nick.to_s
    end

    # Search a `Chan` in the list `chans` by name (including '#')
    # If the chan is not found, then it raise an error
    def chan(chan_name : String) : Chan
      chan = self.chans.bsearch { |e| e.name == chan_name }.as(Chan)
      raise IrcError.new("Cannot find the chan \"#{chan_name}\"") if chan.nil?
      chan.as(Chan)
    end
  end
end
