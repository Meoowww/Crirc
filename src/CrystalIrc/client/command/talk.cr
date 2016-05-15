module CrystalIrc
  class Client
    module Command

      module Talk
        def notice(target : User, msg : String)
          send_raw "NOTICE #{target.name} :#{msg}"
        end

        def privmsg(target : User, msg : String)
          send_raw "PRIVMSG #{target.name} :#{msg}"
        end
      end

    end
  end
end
