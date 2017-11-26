module Crirc::Test::Controller::Command::User
  include Crirc::Controller::Command::User
  extend self

  def puts(data)
    data.strip
  end
end

describe Crirc::Controller::Command::User do
  it "basic test" do
    target = Crirc::Protocol::User.new "nyupnyup"
    Crirc::Test::Controller::Command::User.whois(target).should eq("WHOIS nyupnyup")
    Crirc::Test::Controller::Command::User.whowas(target).should eq("WHOWAS nyupnyup")
    Crirc::Test::Controller::Command::User.mode(target, "abcd").should eq("MODE nyupnyup abcd")
  end
end
