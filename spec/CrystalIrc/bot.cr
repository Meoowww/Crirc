describe CrystalIrc::Bot do

  it "Instance and basic hooking" do
    bot = CrystalIrc::Bot.new ip: "localhost", nick: "DashieLove"
    bot.should be_a(CrystalIrc::Bot)
    bot.on("TOTO") { |irc, msg| msg.arguments.should eq("") }.should be(bot)
    bot
      .on("TOTO") { |irc, msg| msg.arguments.should eq("") }
      .on("TOTO") { |irc, msg| msg.arguments.should eq("") }
      .on("TATA") { |irc, msg| msg.arguments.should eq("is true") }
    bot.handle(CrystalIrc::Message.new ":from TOTO", bot).should be(bot)
    bot
      .handle(CrystalIrc::Message.new ":from TATA is true", bot)
      .handle(CrystalIrc::Message.new ":from TITI", bot)
    #except_raise(CrystalIrc::InvalidMessage){ bot.handle("violation") }
  end

end
