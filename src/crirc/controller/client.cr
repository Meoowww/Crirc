require "../network/client"
require "../binding/handler"

class Crirc::Controller::Client
  include Binding::Handler
  getter network : Network::Client

  delegate nick, to: :network

  delegate puts, to: :network
  delegate gets, to: :network

  def initialize(@network)
    super()
  end

  def init
    @network.puts "PASS #{@network.pass}" if @network.pass
    @network.puts "NICK #{@network.nick.to_s}"
    @network.puts "USER #{@network.user.to_s} \"#{@network.domain}\" \"#{@network.irc_server}\" :#{@network.realname.to_s}"
  end

  def on_ready(&b) : Client
    self.on("001") { b.call }
    self
  end
end
