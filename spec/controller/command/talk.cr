module Crirc::Test::Controller::Command::Talk
  include Crirc::Controller::Command::Talk
  extend self

  def puts(data)
    data.strip
  end
end

describe Crirc::Controller::Command::Talk do
  it "basic test" do
    target = Crirc::Protocol::User.new "nyupnyup"
    Crirc::Test::Controller::Command::Talk.notice(target, "This is a very important notice").should eq("NOTICE nyupnyup :This is a very important notice")
    Crirc::Test::Controller::Command::Talk.privmsg(target, "This is a test message").should eq("PRIVMSG nyupnyup :This is a test message")
  end
end
