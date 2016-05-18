describe CrystalIrc::Bot do

  it "Instance and basic hooking" do
    bot = CrystalIrc::Bot.new ip: "localhost", nick: "DashieLove"
    bot.should be_a(CrystalIrc::Bot)
    bot.on("TOTO", ->(source : String, args : String) { args.should eq(""); true }).should be(bot)
    bot.on("TOTO", ->(source : String, args : String) { args.should eq(""); true })
      .on("TOTO",  ->(source : String, args : String) { args.should eq(""); true })
      .on("TATA",  ->(source : String, args : String) { args.should eq("is true"); true })
    bot.handle(":from TOTO").should be(bot)
    bot.handle(":from TATA is true").handle(":from TITI")
    #except_raise(CrystalIrc::InvalidMessage){ bot.handle("violation") }
  end

end
