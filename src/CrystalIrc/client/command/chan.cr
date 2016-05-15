module CrystalIrc
  class Client
    module Command

      module Chan
        # Format the chans to join: #chan1,#chan2
        def format_chans(chans : Array(Chan))
          chans do |c|
            c.name
          end.to_a.join(",")
        end

        def join(chans : Array(Chan), passwords : Array(String) = [""])
          to_join = format_chans(chans)
          passes = format_chans(passwords)
          send_raw "JOIN #{to_join} #{passes}"
        end

        def part(chans : Array(Chan), msg : String = "")
          to_leave = format_chans(chans)
          msg = msg.length > 0 ? ":" + msg : msg
          send_raw "PART #{to_leave} #{msg}"
        end

        def mode(chan : Chan, flags : String, user : User = Nil)
          target = user ? user.name : ""
          send_raw "MODE #{chan.name} #{flags} #{target}"
        end

        def topic(chan : Chan, topic : String = "")
          topic = topic.length > 0 ? ":" + topic : ""
          send_raw "TOPIC #{chan.name} #{topic}"
        end

        def names(chans : Array(Chan) = Nil)
          target = chans == Nil ? "" : format_chans(chans)
          send_raw "NAMES #{target}"
        end

        def list(chans : Array(Chan) = Nil)
          target = chans == Nil ? "" : format_chans(chans)
          send_raw "LIST #{target}"
        end

        def invite(chan : Chan, user : User)
          send_raw "INVITE #{user.name} #{chan.name}"
        end

        def kick(chans : Array(Chan), users : Array(User), reason : String = "")
          chan = format_chans(chans)
          targets = format_chans(users)
          reason = reason > 0 ? ":" + reason : reason
          send_raw "KICK #{chan} #{targets} #{reason}"
        end
      end

    end
  end
end
