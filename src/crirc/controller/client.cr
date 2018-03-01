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

  # TODO Not used yet
  getter chanlist : ChanList

  # delegated to the `Network`
  delegate nick, to: :network
  # delegated to the `Network`
  delegate puts, to: :network
  # delegated to the `Network`
  delegate gets, to: :network

  # New `Client` that controls the given `Network`.
  def initialize(@network)
    super()
    @chanlist = ChanList.new
  end

  # Initialize the connection with the IRC server (send pass, nick and user).
  def init
    puts "PASS #{@network.pass}" if @network.pass
    puts "NICK #{@network.nick.to_s}"
    puts "USER #{@network.user.to_s} \"#{@network.domain}\" \"#{@network.irc_server}\" :#{@network.realname.to_s}"
  end

  # Start the callback when the server is ready to receive messages.
  #
  # ```
  # bot.on_ready do
  #   amazing_stuff(bot)
  # end
  # ```
  def on_ready(&b) : Client
    self.on("001") { b.call }
    self
  end

  # Reply to a given message with a privmsg.
  #
  # ```
  # bot.on("JOIN") do |msg, _|
  #   nick = msg.source.source_nick
  #   context.reply(msg, "Welcome to #{nick}")
  # end
  # ```
  def reply(msg, data)
    target = msg.argument_list.first
    target_object = (target[0] == '#' ? Crirc::Protocol::Chan : Crirc::Protocol::User).new(target).as(Crirc::Protocol::Target)
    self.privmsg(target_object, data)
  end
end
