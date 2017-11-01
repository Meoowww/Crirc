require "../network/client"

class Crirc::Controller::Client
  getter network : Network::Client

  def initialize(@network)
  end

  def start
  end
end
