module Crirc::Test::Controller::Command::Ping
  include Crirc::Controller::Command::Ping
  extend self
  def puts(data)
    data
  end
end

describe Crirc::Controller::Command::Ping do
  it "basic test" do
    Crirc::Test::Controller::Command::Ping.ping("0").should eq("0")
  end
end
