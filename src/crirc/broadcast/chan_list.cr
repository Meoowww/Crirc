require "../protocol/chan"
require "./user_list"
require "./broadcast"

class Crirc::ChanList
  getter chans : Hash(Protocol::Chan, UserList)
  include Broadcast

  def initialize
    @chans = Hash(Protocol::Chan, UserList).new
  end

  # Broadcast a message to the users
  def send
  end
end
