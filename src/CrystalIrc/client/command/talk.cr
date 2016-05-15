module CrystalIrc
  class Client
    module Command

      module Talk
        # Send a notice to the given target.
        def notice(target : User, msg : String)
          send_raw "NOTICE #{target.name} :#{msg}"
        end

        # Send a private message to the given target.
        def privmsg(target : User, msg : String)
          send_raw "PRIVMSG #{target.name} :#{msg}"
        end
      end

    end
  end
end
