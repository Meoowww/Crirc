require "./client"

module CrystalIrc
  class Bot < Client
    include CrystalIrc::Handler
  end
end
