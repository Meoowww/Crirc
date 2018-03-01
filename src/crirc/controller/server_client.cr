require "../network/server_client"
require "./controller"

# TODO
# Handles the clients connected to a `Server`
class Crirc::Controller::ServerClient
  include Controller

  getter network : Network::ServerClient

  delegate puts, to: :network
  delegate gets, to: :network

  def initialize(@network)
  end
end
