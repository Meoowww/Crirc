module CrystalIrc
  class Client
    module Command

      module Chan
        # Formats the chans to join: #chan1,#chan2
        def format_chans(chans : Array(Chan))
          chans.map do |c|
            c.name
          end.uniq.join(",")
        end

        # Requests to join the chan(s) chans, with password(s) passwords.
        # The passwords may be ignored if not needed.
        def join(chans : Array(Chan), passwords : Array(String) = [""])
          to_join = format_chans(chans)
          passes = format_chans(passwords)
          send_raw "JOIN #{to_join} #{passes}"
        end

        # Requests to leave the channel(s) chans, with an optional part message msg.
        def part(chans : Array(Chan), msg : String?)
          to_leave = format_chans(chans)
          msg = ":#{msg}" if msg
          send_raw "PART #{to_leave} #{msg}"
        end

        # Requests to change the mode of the given channel.
        # If the mode is to be applied to an user, precise it.
        def mode(chan : Chan, flags : String, user : User?)
          target = user ? user.name : ""
          send_raw "MODE #{chan.name} #{flags} #{target}"
        end

        # Requests to change the topic of the given channel.
        # If no topic is given, requests the topic of the given channel.
        def topic(chan : Chan, topic : String?)
          topic = ":#{topic}" if topic
          send_raw "TOPIC #{chan.name} #{topic}"
        end

        # Requests the names of the users in the given channel(s).
        # If no channel is given, requests the names of the users in every
        # known channel.
        def names(chans : Array(Chan)?)
          target = chans ? format_chans(chans) : ""
          send_raw "NAMES #{target}"
        end

        # Lists the channels and their topics.
        # If the chans parameter is given, lists the status of the given chans.
        def list(chans : Array(Chan)?)
          target = chans ? format_chans(chans) : ""
          send_raw "LIST #{target}"
        end

        # Invites the user user to the channel chan.
        def invite(chan : Chan, user : User)
          send_raw "INVITE #{user.name} #{chan.name}"
        end

        # Kicks the user(s) users from the channel(s) chans.
        # The reason of the kick will be displayed if given as a parameter.
        def kick(chans : Array(Chan), users : Array(User), reason : String?)
          chan = format_chans(chans)
          targets = format_chans(users)
          reason = ":#{reason}" if reason
          send_raw "KICK #{chan} #{targets} #{reason}"
        end
      end

    end
  end
end
