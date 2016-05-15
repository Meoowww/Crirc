require "./client/*"

module CrystalIrc

  class Client
    include CrystalIrc::Client::Connect
    include CrystalIrc::Client::Ping
    include CrystalIrc::Client::Command
    include CrystalIrc::Client::Command::Chan
    include CrystalIrc::Client::Command::Talk
    include CrystalIrc::Client::Command::User

    @nick       : String
    @ip         : String
    @port       : UInt16
    @ssl        : Bool
    @socket     : TCPSocket?
    @user       : String?
    @realname   : String?
    @domain     : String?
    @pass       : String?
    @irc_server : String?

    getter nick, ip, port, ssl, user, realname, domain, pass, irc_server

    def initialize(@nick, @ip, @port, @ssl = true, @user = nil, @realname = nil, @domain = nil, @pass = nil, @irc_server = nil)
      @user ||= nick
      @realname ||= nick
      @domain ||= "0"
      @irc_server ||= "*"
    end

    # The client has to call connect() before using socket.
    # If the socket is not setup, it will rase a NoConnection error
    def socket : TCPSocket
      raise NoConnection.new "Socket is not set. Use connect(...) before." unless @socket
      @socket as TCPSocket
    end

    # Send a raw message to the socket. It should be a valid command
    # TODO: handle too large messages
    def send_raw(raw : String)
      socket.puts raw
    end
  end

end
