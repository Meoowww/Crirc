$counter_toto = 0

describe CrystalIrc::Bot do
  it "Instance and basic hooking" do
    $counter_toto = 0
    bot = CrystalIrc::Bot.new ip: "localhost", nick: "DashieLove"
    bot.should be_a(CrystalIrc::Bot)
    bot.on("TOTO") { |msg| msg.raw_arguments.should eq(""); $counter_toto += 1 }.should be(bot)
    bot
      .on("TOTO") { |msg| msg.raw_arguments.should eq(""); $counter_toto += 1 }
      .on("TOTO") { |msg| msg.raw_arguments.should eq(""); $counter_toto += 1 }
      .on("TATA") { |msg| msg.raw_arguments.should eq("is true") }
    bot.handle(CrystalIrc::Message.new ":from TOTO", bot).should be(bot)
    $counter_toto.should eq(3)
    bot
      .handle(CrystalIrc::Message.new ":from TATA is true", bot)
      .handle(CrystalIrc::Message.new ":from TITI", bot)
      .handle(":from TITI")
      .handle(":from TOTO")
    $counter_toto.should eq(6)
    bot.on("TOTO") { |msg| msg.raw_arguments.should eq(""); $counter_toto += 1 }.should be(bot)
    bot.handle(":from TOTO")
    $counter_toto.should eq(10)
    expect_raises(CrystalIrc::ParsingError) { bot.handle("violation") }
    expect_raises(CrystalIrc::ParsingError) { bot.handle(":from bad") }
  end

  it "Hooking with advanced rules" do
    $counter_toto = 0
    bot = CrystalIrc::Bot.new ip: "localhost", nick: "DashieLove"
    bot
      .on("TOTO") { |msg| $counter_toto += 1 }
      .on("TOTO", message: /^what(?<first>.*)/) { |msg, match|
      (match.as(Regex::MatchData))["first"] == " is love" if msg.message.to_s.size > 4
      msg.message.should eq("what is love"); $counter_toto += 1
    }
    bot.handle(":s TOTO")
    $counter_toto.should eq(1)
    bot.handle(":s TOTO arg :what is love")
    $counter_toto.should eq(3)
    bot.handle(":s TOTO arg :this is love")
    $counter_toto.should eq(4)
  end
end
