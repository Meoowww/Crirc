require "../irc_sender"
require "../protocol/user"

# Represent a client, from the point of view of the server.
class CrystalIrc::Server::Client < CrystalIrc::IrcSender
  enum ValidationStates
    None
    Nick
    User
    Valid
  end

  @socket : TCPSocket
  getter user : CrystalIrc::User
  getter valid : ValidationStates
  property username : String
  property realname : String

  def initialize(@socket)
    @user = CrystalIrc::User.new "Default" + Random.rand(10000).to_s
    @valid = ValidationStates::None
    @username = ""
    @realname = ""
  end

  def validate(type)
    if type == ValidationStates::Nick
      if @valid == ValidationStates::User
        @valid = ValidationStates::Valid
      else
        @valid = ValidationStates::Nick
      end
    elsif type == ValidationStates::User
      if @valid == ValidationStates::Nick
        @valid = ValidationStates::Valid
      else
        @valid = ValidationStates::User
      end
    end
  end

  def valid?
    @valid == ValidationStates::Valid
  end

  protected def socket
    @socket
  end

  def from
    user.nick # TODO: find the client through the Server.users
  end
end
