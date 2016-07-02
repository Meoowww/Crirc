module CrystalIrc
  module Command
    module User
      # Requests data about the given target.
      def whois(target : CrystalIrc::User)
        send_raw "WHOIS #{target.name}"
      end

      # Requests data bout the user who used the given name.
      def whowas(target : CrystalIrc::User)
        send_raw "WHOWAS #{target.name}"
      end

      # Requests to set the mode of the given target to flag.
      def mode(target : CrystalIrc::User, flag : String)
        send_raw "MODE #{target.name} #{flag}"
      end
    end
  end
end
