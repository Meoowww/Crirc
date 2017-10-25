require "./irc_sender"

class CrystalIrc::Server < CrystalIrc::IrcSender
end

require "./server/*"
require "./protocol/chan"

class CrystalIrc::Server
  include CrystalIrc::Handler
  # include CrystalIrc::Server::Binding

  getter socket : TCPServer
  @host : String
  @port : UInt16
  @ssl : Bool
  @clients : Array(CrystalIrc::Server::Client)
  @chans : Hash(CrystalIrc::Chan, Array(CrystalIrc::Server::Client))
  @verbose : Bool

  getter host, port, socket, chans, clients

  # TODO: maybe new should be protected
  # TODO: add ssl socket
  def initialize(@host = "127.0.0.1", @port = 6697_16, @ssl = true, @verbose = false)
    @socket = TCPServer.new(@host, @port)
    STDOUT.puts "Server listen on #{@host}:#{@port}" if @verbose
    @clients = Array(CrystalIrc::Server::Client).new
    @chans = Hash(CrystalIrc::Chan, Array(CrystalIrc::Server::Client)).new
    super()
    CrystalIrc::Server::Binding.attach(self)
  end

  def self.open(host = "127.0.0.1", port = 6697_u16, ssl = true)
    s = new host, port, ssl
    begin
      yield s
    ensure
      s.close
    end
  end

  def accept(&block)
    STDOUT.puts "Wait for client"
    @socket.accept do |s|
      STDOUT.puts "Client connected"
      cli = CrystalIrc::Server::Client.new s
      begin
        STDOUT.puts "Add client to the list"
        @clients << cli
        STDOUT.puts "Client execution"
        yield cli
      ensure
        STDOUT.puts "Client stop"
        cli.close
        @clients.delete cli
      end
    end
  end

  def accept
    STDOUT.puts "Wait for client"
    cli_socket = @socket.accept
    cli = CrystalIrc::Server::Client.new cli_socket
    STDOUT.puts "Add client to the list"
    @clients << cli
    cli
  end

  def close
    STDOUT.puts "Clean the connections and server"
    @clients.each { |c| c.close }
    @clients.clear
    super
  end

  def from
    "0"
  end
end
