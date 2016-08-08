module CrystalIrc
  class Client
    # Default binding on the client.
    # Handles the classic behavior of a client.
    # ping, join, names, etc.
    module Binding
      def self.attach(obj)
        attach_chans(obj)
        attach_other(obj)
      end

      def self.attach_chans(obj)
        obj.on("JOIN") do |msg|
          # Two cases: the client joins a chan or another user joins a chan
          if msg.source_nick == obj.nick # the client joined
            chan = Chan.new(msg.arguments.first)
            obj.chans << chan
          else # someone else joined
            chan = obj.chans.bsearch { |e| e.name == msg.arguments.first }
            if chan
              chan.as(Chan).users << User.new name
            else
              chan = Chan.new(msg.arguments.first)
              obj.chans << chan
            end
          end
        end

        obj.on("PART") do |msg|
          chan = obj.chans.bsearch { |e| e.name == msg.arguments.first }
          if !chan
            STDERR.puts "Chan not registered"
            next # raise?
          end
          if msg.source_nick == obj.nick # the client left
            obj.chans.delete(chan)
          else # someone else left
            user = chan.as(Chan).users.bsearch { |e| e.name == name }
            chan.as(Chan).users.delete(user)
          end
        end

        obj.on("KICK") do |msg|
          name = msg.arguments[1]
          chan = obj.chans.bsearch { |e| e.name == msg.arguments.first }
          if !chan
            STDERR.puts "Chan not registered"
            next # raise?
          end
          if name == obj.nick # the client just got kicked
            obj.chans.delete(chan)
          else # someone else has been kicked
            user = chan.as(Chan).users.bsearch { |e| e.name == name }
            chan.as(Chan).users.delete(user)
          end
        end

        self
      end

      def self.attach_other(obj)
        obj.on("PING") do |msg|
          msg.sender.pong(msg.message)
        end

        obj.on("353") do |msg|
          name = msg.arguments[2]
          chan = obj.chans.bsearch { |e| e.name == name }
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
      #
    end
  end
end
