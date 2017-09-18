def cli
  CrystalIrc::Client.new nick: "a", ip: "localhost"
end

describe CrystalIrc::Message do
  it "Basics instance" do
    m = CrystalIrc::Message.new(":source CMD arg1 arg2 :message", cli)
    m.source.should eq("source")
    m.command.should eq("CMD")
    m.raw_arguments.should eq("arg1 arg2 :message")
    m.arguments.should eq(%w(arg1 arg2 message))
    m.message.should eq("message")
    m.hl.should eq("source")
  end

  it "Instance with no message" do
    m = CrystalIrc::Message.new(":source CMD arg1 arg2", cli)
    m.source.should eq("source")
    m.command.should eq("CMD")
    m.raw_arguments.should eq("arg1 arg2")
    m.arguments.should eq(%w(arg1 arg2))
    m.message.should eq(nil)
    m.hl.should eq("source")
  end

  it "Instance with empty message" do
    m = CrystalIrc::Message.new(":source CMD arg1 arg2 :", cli)
    m.source.should eq("source")
    m.command.should eq("CMD")
    m.raw_arguments.should eq("arg1 arg2")
    m.arguments.should eq(%w(arg1 arg2))
    m.message.should eq(nil)
    m.hl.should eq("source")
  end

  it "Instance with no arguments" do
    m = CrystalIrc::Message.new(":source CMD :message", cli)
    m.source.should eq("source")
    m.command.should eq("CMD")
    m.raw_arguments.should eq(":message")
    m.arguments.should eq(%w(message))
    m.message.should eq("message")
    m.hl.should eq("source")
  end

  it "Instance with no source" do
    m = CrystalIrc::Message.new("CMD arg1 arg2 :message", cli)
    m.source.should eq("0")
    m.command.should eq("CMD")
    m.raw_arguments.should eq("arg1 arg2 :message")
    m.arguments.should eq(%w(arg1 arg2 message))
    m.message.should eq("message")
    m.hl.should eq("0")
  end

  it "PRIVMSG" do
    m = CrystalIrc::Message.new(":nik!usr@whos PRIVMSG #chan :cut my ***", cli)
    m.chan.should be_a(CrystalIrc::Chan)
    m.chan.as(CrystalIrc::Chan).name.should eq("#chan")
    m.hl.should eq("nik")
    m.source_nick.should eq("nik")
    m.source_id.should eq("usr")
    m.source_whois.should eq("whos")
  end
end
