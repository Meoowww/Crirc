require "../network/server_client"

class Crirc::Controller::ServerClient
  getter network : Network::ServerClient

  def initialize(@network)
  end

  def start
  end
end
