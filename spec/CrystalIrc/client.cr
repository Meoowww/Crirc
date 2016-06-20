def test_cli(cli : CrystalIrc::Client, chan = "#nyupatate")
  cli.connect do |s|
    s.should be_a(CrystalIrc::IrcSender)
    spawn do
      loop { cli.gets {|msg| puts "> #{msg}"} }
    end
    sleep 1
    chan = CrystalIrc::Chan.new(chan as String)
    cli.join([chan])
    cli.privmsg(target: chan, msg: "I'm a dwarf and I'm digging a hole. Diggy diggy hole.")
    sleep 1
  end
end

describe CrystalIrc::Client do

  it "Instance without network" do
    CrystalIrc::Client.new(ip: "localhost", port: 6667_u16, ssl: false, nick: "CrystalBot").should be_a(CrystalIrc::Client)
    CrystalIrc::Client.new(ip: "localhost", nick: "CrystalBot").should be_a(CrystalIrc::Client)
    sleep 0.5
  end

  it "Test with irc.mozilla.net" do
    ENV.fetch("OFFLINE") { |v|
      next if v == "true"
      cli = CrystalIrc::Client.new ip: "irc.mozilla.org", port: 6667_u16, ssl: false, nick: "CrystalBotSpecS_#{rand 100..999}"
      cli.should be_a(CrystalIrc::Client)
      test_cli cli
      sleep 0.5
    }
  end

  it "Instance and simple connexion with ssl" do
    ENV.fetch("OFFLINE") { |v|
      cli = CrystalIrc::Client.new ip: "irc.mozilla.org", port: 6697_u16, ssl: true, nick: "CrystalBotSpecS_#{rand 100..999}"
      cli.connect
      cli.close
      sleep 0.5
    }
  end

  it "Test with irc.mozilla.net with ssl" do
    ENV.fetch("OFFLINE") { |v|
      next if v == "true"
      cli = CrystalIrc::Client.new ip: "irc.mozilla.org", port: 6697_u16, ssl: true, nick: "CrystalBotSpecS_#{rand 100..999}"
      cli.should be_a(CrystalIrc::Client)
      test_cli cli
      cli.close
      sleep 0.5
    }
  end

  it "Test close with server" do
    CrystalIrc::Server.open(ssl: false, port: 6666_u16) do |server|
      cli = CrystalIrc::Client.new ip: "localhost", port: 6666_u16, ssl: false, nick: "CrystalBotSpecS_#{rand 100..999}"
      cli.connect do |_|
        cli.closed?.should eq(false)
        cli.close
        cli.closed?.should eq(true)
        expect_raises { cli.gets {} }
      end
    end
    sleep 0.5
  end

end
