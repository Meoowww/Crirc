describe Crirc::Protocol::Message do
  it "Basics instance" do
    m = Crirc::Protocol::Message.new(":source CMD arg1 arg2 :message")
    m.source.should eq("source")
    m.command.should eq("CMD")
    m.raw_arguments.should eq("arg1 arg2 :message")
    m.arguments.should eq("arg1 arg2")
    m.argument_list.should eq(%w(arg1 arg2 message))
    m.message.should eq("message")
  end

  it "Instance with no message" do
    m = Crirc::Protocol::Message.new(":source CMD arg1 arg2")
    m.source.should eq("source")
    m.command.should eq("CMD")
    m.raw_arguments.should eq("arg1 arg2")
    m.arguments.should eq("arg1 arg2")
    m.argument_list.should eq(%w(arg1 arg2))
    m.message.should eq(nil)
  end

  it "Instance with empty message" do
    m = Crirc::Protocol::Message.new(":source CMD arg1 arg2 :")
    m.source.should eq("source")
    m.command.should eq("CMD")
    m.raw_arguments.should eq("arg1 arg2")
    m.arguments.should eq("arg1 arg2")
    m.argument_list.should eq(%w(arg1 arg2))
    m.message.should eq(nil)
  end

  it "Instance with no arguments" do
    m = Crirc::Protocol::Message.new(":source CMD :message")
    m.source.should eq("source")
    m.command.should eq("CMD")
    m.raw_arguments.should eq(":message")
    m.arguments.should eq(nil)
    m.argument_list.should eq(%w(message))
    m.message.should eq("message")
  end

  it "Instance with no source" do
    m = Crirc::Protocol::Message.new("CMD arg1 arg2 :message")
    m.source.should eq("0")
    m.command.should eq("CMD")
    m.raw_arguments.should eq("arg1 arg2 :message")
    m.arguments.should eq("arg1 arg2")
    m.argument_list.should eq(%w(arg1 arg2 message))
    m.message.should eq("message")
  end

  it "PRIVMSG" do
    m = Crirc::Protocol::Message.new(":nik!usr@whos PRIVMSG #chan :cut my ***")
    # m.chan.should be_a(Crirc::Chan)
    # m.chan.as(Crirc::Chan).name.should eq("#chan")
    # m.source_nick.should eq("nik")
    # m.source_id.should eq("usr")
    # m.source_whois.should eq("whos")
  end
end
