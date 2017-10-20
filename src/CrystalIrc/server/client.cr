require "../irc_sender"
require "../protocol/user"

# Represent a client, from the point of view of the server.
class CrystalIrc::Server::Client < CrystalIrc::IrcSender
  @socket : TCPSocket
  @user : CrystalIrc::User

  getter user

  def initialize(@socket)
    @user = CrystalIrc::User.new "Default"
  end

  protected def socket
    @socket
  end

  def from
    user.nick # TODO: find the client through the Server.users
  end
end
