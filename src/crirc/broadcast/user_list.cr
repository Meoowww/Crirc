require "../protocol/user"
require "./broadcast"
require "../controller/controller"

class Crirc::UserList
  getter users : Array(Protocol::User)
  include Broadcast

  def initialize
    @users = Array(Protocol::User)
  end

  # Broadcast a message to the users
  def puts(context : Controller::Controller, data)
    @users.each { context.puts data }
  end
end
