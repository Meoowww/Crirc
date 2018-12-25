require "../protocol/chan"
require "./user_list"
require "./broadcast"

# TODO
# A ChanList is the associated list of `Protocol::Chan` and a `UserList`.
# It is useful for a server that need to keep a track of all the uers
# connected to any of its chans.
class Crirc::ChanList
  getter chans : Hash(Protocol::Chan, UserList)
  include Broadcast

  def initialize
    @chans = Hash(Protocol::Chan, UserList).new
  end

  # TODO
  # Broadcast a message to the users
  def puts(context : Controller::Controller, data)
    @chans.each { |chan, userlist| userlist.puts context, data }
  end
end
