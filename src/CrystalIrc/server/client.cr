require "../irc_sender"
require "../protocol/user"

# Represent a client, from the point of view of the server.
class CrystalIrc::Server::Client < CrystalIrc::IrcSender
  @socket : TCPSocket
  @user : CrystalIrc::User
  @valid : Bool
  @username : String
  @realname : String

  getter user, valid
  setter username, realname

  def initialize(@socket)
    @user = CrystalIrc::User.new "Default" + Random.rand(10000).to_s
    @valid = false
    @username = "guest"
    @realname = "guest"
  end

  def validate()
    @valid = true
  end

  protected def socket
    @socket
  end

  def from
    user.nick # TODO: find the client through the Server.users
  end
end
