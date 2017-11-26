module Crirc::Test::Controller::Command::Ping
  include Crirc::Controller::Command::Ping
  extend self

  def puts(data)
    data.strip
  end
end

describe Crirc::Controller::Command::Ping do
  it "basic test" do
    Crirc::Test::Controller::Command::Ping.ping("0").should eq("PING :0")
    Crirc::Test::Controller::Command::Ping.ping.should eq("PING :0")
    Crirc::Test::Controller::Command::Ping.pong("0").should eq("PONG :0")
    Crirc::Test::Controller::Command::Ping.pong.should eq("PONG :0")
  end
end
