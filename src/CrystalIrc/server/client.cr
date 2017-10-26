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

  # Validate the user has send a required information (NICK, USER)
  def validate(state) : self
    if state == ValidationStates::Nick
      if @valid == ValidationStates::User
        @valid = ValidationStates::Valid
      else
        @valid = ValidationStates::Nick
      end
    elsif state == ValidationStates::User
      if @valid == ValidationStates::Nick
        @valid = ValidationStates::Valid
      else
        @valid = ValidationStates::User
      end
    end
    self
  end

  # Verify the user has validated all the required information (NICK & USER)
  def valid? : Bool
    @valid == ValidationStates::Valid
  end

  protected def socket
    @socket
  end

  # TODO: find the client through the Server.users
  def from
    user.nick
  end
end
