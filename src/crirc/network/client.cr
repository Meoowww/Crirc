require "socket"
require "openssl"
require "../controller/client"
require "./network"

class Crirc::Network::Client
  include Network

  alias IrcSocket = TCPSocket | OpenSSL::SSL::Socket::Client

  getter nick : String
  getter ip : String
  getter port : UInt16
  getter ssl : Bool
  @socket : IrcSocket?
  getter user : String
  getter realname : String
  getter domain : String?
  getter pass : String?
  getter irc_server : String?
  getter read_timeout : UInt16
  getter write_timeout : UInt16
  getter keepalive : Bool

  # default port is 6667 or 6697 if ssl is true
  def initialize(@nick : String, @ip, port = nil.as(UInt16?), @ssl = true, user = nil, realname = nil, @domain = nil, @pass = nil, @irc_server = nil,
                 @read_timeout = 120_u16, @write_timeout = 5_u16, @keepalive = true)
    @port = port.to_u16 || (ssl ? 6697_u16 : 6667_u16)
    @user = user || @nick
    @realname = realname || @nick
    @domain ||= "0"
    @irc_server ||= "*"
  end

  def socket
    raise "Socket is not set. Add `client.connect()` before using `client.socket`" if @socket.nil?
    @socket.as(IrcSocket)
  end

  # Connect to the target server
  def connect
    tcp_socket = TCPSocket.new(@ip, @port)
    tcp_socket.read_timeout = @read_timeout
    tcp_socket.write_timeout = @write_timeout
    tcp_socket.keepalive = @keepalive
    @socket = tcp_socket
    @socket = OpenSSL::SSL::Socket::Client.new(tcp_socket) if @ssl
    self
  end

  # Start a new Controller::Client binded to the current object
  def start(&block)
    controller = Controller::Client.new(self)
    controller.init
    yield controller
  end

  # Wait and fetch the next incoming message
  def gets
    socket.gets
  end

  # Send a message to the server
  def puts(data)
    socket.puts data.strip
    socket.puts "\r\n"
    socket.flush
  end

  # End the connection
  def close
    socket.close
    @socket = nil
  end
end
