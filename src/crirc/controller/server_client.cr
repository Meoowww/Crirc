require "../network/server_client"
require "./controller"

class Crirc::Controller::ServerClient
  include Controller

  getter network : Network::ServerClient

  delegate puts, to: :network
  delegate gets, to: :network

  def initialize(@network)
  end
end
