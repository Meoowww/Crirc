require "./network"

class Crirc::Network::ServerClient
  include Network

  def initialize
  end

  # Wait and fetch the next incoming message
  def gets
  end

  # Send a message to the server
  def puts(data)
  end
end
