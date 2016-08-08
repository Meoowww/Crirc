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
        end.on("353") do |msg|
          name = msg.arguments[2]
          chan = obj.chans.bsearch{|e| e.name == name }
          if chan.nil?
            STDERR.puts "\"#{name}\" is not a valid chan"
            next # TODO : raise ?
          else
            chan.users = msg.arguments.last.split(" ").map do |name|
              User.new name.delete("@+")
            end
          end
        end
        self
      end
    end
  end
end
