module CrystalIrc
  class Client
    module Command

      module User
        def whois(target : User)
          send_raw "WHOIS #{target.name}"
        end

        def whowas(target : User)
          send_raw "WHOWAS #{target.name}"
        end

        def mode(target : User, flag : String)
          send_raw "MODE #{target.name} #{flag}"
        end
      end

    end
  end
end
