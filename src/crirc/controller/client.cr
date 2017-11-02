require "../network/client"
require "../binding/handler"
require "./controller"
require "../broadcast/chan_list"
require "./command/*"

class Crirc::Controller::Client
  include Crirc::Controller::Command::Ping
  include Crirc::Controller::Command::User
  include Crirc::Controller::Command::Talk
  include Crirc::Controller::Command::Chan

  include Controller
  # It has to be the last module included so initialize { super() } works
  include Binding::Handler

  getter network : Network::Client
  getter chanlist : ChanList

  delegate nick, to: :network
  delegate puts, to: :network
  delegate gets, to: :network

  def initialize(@network)
    super()
    @chanlist = ChanList.new
  end

  def init
    puts "PASS #{@network.pass}" if @network.pass
    puts "NICK #{@network.nick.to_s}"
    puts "USER #{@network.user.to_s} \"#{@network.domain}\" \"#{@network.irc_server}\" :#{@network.realname.to_s}"
  end

  def on_ready(&b) : Client
    self.on("001") { b.call }
    self
  end
end
