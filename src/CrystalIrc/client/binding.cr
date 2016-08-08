module CrystalIrc
  class Client
    # Default binding on the client.
    # Handles the classic behavior of a client.
    # ping, join, names, etc.
    module Binding
      def self.attach(obj)
        obj.on("JOIN") do |msg|
          # Two cases: the client joins a chan or another user joins a chan
          name = ""
          if msg.source
            name = msg.source.as(String).split("!")[0]
          else
            STDERR.puts "No one entered the chan"
          end
          if name == obj.nick # First case: the client joined the chan
            chan = Chan.new(msg.arguments.first)
            obj.chans << chan
          else # Second case: another user joined the chan
            chan = obj.chans.bsearch{|e| e.name == msg.arguments.first }
            if chan
              chan.as(Chan).users << User.new name
            else
              chan = Chan.new(msg.arguments.first)
              obj.chans << chan
            end
          end
        end.on("PART") do |msg|

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
