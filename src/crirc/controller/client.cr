require "../network/client"
require "../binding/handler"

class Crirc::Controller::Client
  include Binding::Handler
  getter network : Network::Client

  def initialize(@network)
    super
  end

  def init
    send_raw "PASS #{@network.pass}" if @network.pass
    send_raw "NICK #{@network.nick.to_s}"
    send_raw "USER #{@network.user.to_s} \"#{@network.domain}\" \"#{@network.irc_server}\" :#{@network.realname.to_s}"
  end

  def on_ready(&b) : Client
    self.on("001") { b.call }
    self
  end
end
