describe CrystalIrc::Client do
  it "Test with irc.mozilla.net" do
    ENV.fetch("OFFLINE") do |v|
      next if v == "true"
      cli = CrystalIrc::Client.new ip: "irc.mozilla.org", port: 6667_u16, ssl: false, nick: "CrystalBotSpecS_#{rand 100..999}"
      cli.should be_a(CrystalIrc::Client)
      test_cli1 cli
      cli.close
      sleep 0.5
    end
  end

  it "Instance and simple connexion with ssl" do
    ENV.fetch("OFFLINE") do |v|
      next if v == "true"
      cli = CrystalIrc::Client.new ip: "irc.mozilla.org", port: 6697_u16, ssl: true, nick: "CrystalBotSpecS_#{rand 100..999}"
      cli.connect
      cli.close
      sleep 0.5
    end
  end

  it "Test with irc.mozilla.net with ssl" do
    ENV.fetch("OFFLINE") do |v|
      next if v == "true"
      cli = CrystalIrc::Client.new ip: "irc.mozilla.org", port: 6697_u16, ssl: true, nick: "CrystalBotSpecS_#{rand 100..999}"
      cli.should be_a(CrystalIrc::Client)
      test_cli1 cli
      cli.close
      sleep 0.5
    end
  end
end
