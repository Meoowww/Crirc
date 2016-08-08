# $verbose = true

describe CrystalIrc::Client do
  it "Test with irc.mozilla.net" do
    ENV.fetch("OFFLINE") { |v|
      next if v == "true"
      cli = CrystalIrc::Client.new ip: "irc.mozilla.org", port: 6667_u16, ssl: false, nick: "CrystalBotSpecS_#{rand 100..999}"
      cli.should be_a(CrystalIrc::Client)

      cli.connect do |s|
        s.should be_a(CrystalIrc::IrcSender)
        spawn do
          loop do
            break if cli.closed?
            cli.gets { |msg| cli.handle msg.as(String) } rescue nil
          end
        end
        chan = CrystalIrc::Chan.new("#nyupatate")
        cli.chans.size.should eq 0
        sleep 1
        cli.join([chan])
        sleep 1
        cli.chans.size.should eq 1
        cli.chans[0].users.size.should eq 2
        sleep 1
      end
      cli.close
      sleep 0.5
    }
  end
end
