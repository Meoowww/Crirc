describe Crirc::Binding::Trigger do
  it "simple test" do
    m1 = Crirc::Protocol::Message.new ":source PRIVMSG arguments :message"
    t1 = Crirc::Binding::Trigger.new "PRIVMSG"
    t2 = Crirc::Binding::Trigger.new "PRIVMSG", "source"
    t3 = Crirc::Binding::Trigger.new "PRIVMSG", "source", "arguments"
    t4 = Crirc::Binding::Trigger.new "PRIVMSG", "source", "arguments", "message"
    t1.test(m1).should be_true
    t2.test(m1).should be_true
    t3.test(m1).should be_true
    t4.test(m1).should be_true
  end

  it "simple test" do
    m = Crirc::Protocol::Message.new ":source PRIVMSG nick :!ping me"
    t = Crirc::Binding::Trigger.new "PRIVMSG", message: /^!ping/
    t.test(m).should be_a(Regex::MatchData)
  end
end
