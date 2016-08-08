module CrystalIrc
  class Client
    # Default binding on the client.
    # Handles the classic behavior of a client.
    # ping, join, names, etc.
    module Binding
      def self.attach(obj)
        obj.on("JOIN") do |msg|
          chan = Chan.new(msg.arguments.first)
          obj.chans << chan
        end.on("PING") do |msg|
          msg.sender.pong(msg.message)
        end
        self
      end
    end
  end
end
