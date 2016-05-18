describe CrystalIrc::Bot do

  it "Instance and basic hooking" do
    bot = CrystalIrc::Bot.new ip: "localhost", nick: "DashieLove"
    bot.should be_a(CrystalIrc::Bot)
    bot.on("toto", ->(e : String) { e.should eq("toto"); true }).should be(bot)
    bot.on("toto", ->(e : String) { e.should eq("toto"); true })
      .on("toto", ->(e : String) { e.should eq("toto"); true })
      .on("tata", ->(e : String) { e.should eq("tata is true"); true })
    bot.handle("toto").should be(bot)
    bot.handle("tata is true").handle("rape")
  end

end
