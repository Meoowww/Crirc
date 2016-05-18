$counter_toto = 0

describe CrystalIrc::Bot do

  it "Instance and basic hooking" do
    bot = CrystalIrc::Bot.new ip: "localhost", nick: "DashieLove"
    bot.should be_a(CrystalIrc::Bot)
    bot.on("TOTO") { |irc, msg| msg.arguments.should eq(""); $counter_toto += 1 }.should be(bot)
    bot
      .on("TOTO") { |irc, msg| msg.arguments.should eq(""); $counter_toto += 1 }
      .on("TOTO") { |irc, msg| msg.arguments.should eq(""); $counter_toto += 1 }
      .on("TATA") { |irc, msg| msg.arguments.should eq("is true") }
    bot.handle(CrystalIrc::Message.new ":from TOTO", bot).should be(bot)
    $counter_toto.should eq(3)
    bot
      .handle(CrystalIrc::Message.new ":from TATA is true", bot)
      .handle(CrystalIrc::Message.new ":from TITI", bot)
      .handle(":from TITI")
      .handle(":from TOTO")
    $counter_toto.should eq(6)
    bot.on("TOTO") { |irc, msg| msg.arguments.should eq(""); $counter_toto += 1 }.should be(bot)
    bot.handle(":from TOTO")
    $counter_toto.should eq(10)
    expect_raises(CrystalIrc::InvalidMessage) { bot.handle("violation") }
    expect_raises(CrystalIrc::InvalidMessage) { bot.handle(":from bad") }
  end

end
