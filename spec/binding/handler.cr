class Crirc::Test::Binding::Handler
  include Crirc::Binding::Handler
end

describe Crirc::Binding::Handler do
  it "simple test" do
    m1 = Crirc::Protocol::Message.new ":source PRIVMSG arguments :message"
    t = Crirc::Test::Binding::Handler.new
    async_test = {} of String => Bool
    t.on("PRIVMSG") { |msg, match| async_test["m1"] = true }
    t.on("PRIVMSG", message: "message") { |msg, match| async_test["m2"] = true }
    t.on("PRIVMSG", message: /message/) { |msg, match| async_test["m3"] = true }
    t.handle m1
    async_test["m1"].should be_true
    async_test["m2"].should be_true
    async_test["m3"].should be_true
  end
end
