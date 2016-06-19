require "./irc_sender"
module CrystalIrc
  class Server < CrystalIrc::IrcSender
  end
end

require "./server/*"

module CrystalIrc

  class Server
    include CrystalIrc::Handler

    @host     : String
    @port     : UInt16
    @socket   : TCPServer
    @ssl      : Bool
    @chans    : Hash(String, Hash(CrystalIrc::Chan, Array(CrystalIrc::User)))
    @clients  : Array(CrystalIrc::Server::Client)

    getter host, port, socket, chans, users

    # TODO: maybe new should be protected
    # TODO: add ssl socket
    def initialize(@host = "127.0.0.1", @port = 6697_16, @ssl = true)
      @socket = TCPServer.new(@host, @port)
      @chans = Hash(String, Hash(CrystalIrc::Chan, Array(CrystalIrc::User))).new
      @clients = Array(CrystalIrc::Server::Client).new
      super()
    end

    def self.open(host = "127.0.0.1", port = 6697_u16, ssl = true)
      s = new host, port, ssl
      begin
        yield s
      ensure
        s.close
      end
    end

    def accept
      @socket.accept do |s|
        cli = CrystalIrc::Server::Client.new s
        begin
          @clients << cli
          yield cli
        ensure
          cli.close
          @clients.delete cli
        end
      end
    end

    def accept
      cli = CrystalIrc::Server::Client.new @socket.accept
      @clients << cli
      cli
    end

    def close
      @clients.each{|c| c.close}
      @clients.clear
      @chans.clear
      @socket.close
    end

    protected def socket
      @socket
    end

  end

end
