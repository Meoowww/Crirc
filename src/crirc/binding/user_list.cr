require "../protocol/user"
require "./broadcast"

class Crirc::UserList
  getter users : Array(Protocol::User)
  include Broadcast

  # Broadcast a message to the users
  def send
  end
end
