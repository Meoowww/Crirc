require "../protocol/user"
require "./broadcast"
require "../controller/controller"

# TODO.
# UserList is used to send message to a list of `Protocol::User`.
#
# ```
# chan1 = UserList.new
# chan1.users << user_joined
# chan1.puts current_controller, crafted_message
# ```
class Crirc::UserList
  getter users : Array(Protocol::User)
  include Broadcast

  def initialize
    @users = Array(Protocol::User)
  end

  # TODO
  # NOTE: combine data+user
  # Broadcast a message to the users
  def puts(context : Controller::Controller, data)
    @users.each { |user| context.puts data }
  end
end
