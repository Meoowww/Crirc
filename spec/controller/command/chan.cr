module Crirc::Test::Controller::Command::Chan
  include Crirc::Controller::Command::Chan
  extend self

  def puts(data)
    data.strip
  end
end

describe Crirc::Controller::Command::Chan do
  it "join test" do
    chan = Crirc::Protocol::Chan.new "#patate"
    chan2 = Crirc::Protocol::Chan.new "#nyu"

    Crirc::Test::Controller::Command::Chan.join({chan}).should eq("JOIN #patate")
    Crirc::Test::Controller::Command::Chan.join(chan).should eq("JOIN #patate")
    Crirc::Test::Controller::Command::Chan.join({chan, chan2}).should eq("JOIN #patate,#nyu")
    Crirc::Test::Controller::Command::Chan.join({chan}, {"bloup"}).should eq("JOIN #patate bloup")
    Crirc::Test::Controller::Command::Chan.join({chan, chan2}, {"bloup", "blip"}).should eq("JOIN #patate,#nyu bloup,blip")
  end

  it "part test" do
    chan = Crirc::Protocol::Chan.new "#patate"
    chan2 = Crirc::Protocol::Chan.new "#nyu"

    Crirc::Test::Controller::Command::Chan.part({chan}).should eq("PART #patate")
    Crirc::Test::Controller::Command::Chan.part(chan).should eq("PART #patate")
    Crirc::Test::Controller::Command::Chan.part({chan, chan2}).should eq("PART #patate,#nyu")
    Crirc::Test::Controller::Command::Chan.part({chan}, "I'm out").should eq("PART #patate :I'm out")
    Crirc::Test::Controller::Command::Chan.part(chan, "I'm out").should eq("PART #patate :I'm out")
    Crirc::Test::Controller::Command::Chan.part({chan, chan2}, "I'm out").should eq("PART #patate,#nyu :I'm out")
  end

  it "misc tests" do
    target = Crirc::Protocol::User.new "nyupnyup"
    chan = Crirc::Protocol::Chan.new "#patate"
    chan2 = Crirc::Protocol::Chan.new "#nyu"

    Crirc::Test::Controller::Command::Chan.mode(chan, "+a").should eq("MODE #patate +a")
    Crirc::Test::Controller::Command::Chan.mode(chan, "+b", target).should eq("MODE #patate +b nyupnyup")

    Crirc::Test::Controller::Command::Chan.topic(chan).should eq("TOPIC #patate")
    Crirc::Test::Controller::Command::Chan.topic(chan, "bloup").should eq("TOPIC #patate :bloup")

    Crirc::Test::Controller::Command::Chan.invite(chan, target).should eq("INVITE nyupnyup #patate")
  end

  it "names test" do
    chan = Crirc::Protocol::Chan.new "#patate"
    chan2 = Crirc::Protocol::Chan.new "#nyu"

    Crirc::Test::Controller::Command::Chan.names(nil).should eq("NAMES")
    Crirc::Test::Controller::Command::Chan.names(chan).should eq("NAMES #patate")
    Crirc::Test::Controller::Command::Chan.names({chan}).should eq("NAMES #patate")
    Crirc::Test::Controller::Command::Chan.names({chan, chan2}).should eq("NAMES #patate,#nyu")
  end

  it "list test" do
    chan = Crirc::Protocol::Chan.new "#patate"
    chan2 = Crirc::Protocol::Chan.new "#nyu"

    Crirc::Test::Controller::Command::Chan.list(nil).should eq("LIST")
    Crirc::Test::Controller::Command::Chan.list(chan).should eq("LIST #patate")
    Crirc::Test::Controller::Command::Chan.list({chan}).should eq("LIST #patate")
    Crirc::Test::Controller::Command::Chan.list({chan, chan2}).should eq("LIST #patate,#nyu")
  end

  it "kick test" do
    target = Crirc::Protocol::User.new "nyupnyup"
    target2 = Crirc::Protocol::User.new "gloubi"
    chan = Crirc::Protocol::Chan.new "#patate"
    chan2 = Crirc::Protocol::Chan.new "#nyu"

    Crirc::Test::Controller::Command::Chan.kick({chan}, {target}).should eq("KICK #patate nyupnyup")
    Crirc::Test::Controller::Command::Chan.kick(chan, target).should eq("KICK #patate nyupnyup")
    Crirc::Test::Controller::Command::Chan.kick({chan, chan2}, {target}).should eq("KICK #patate,#nyu nyupnyup")
    Crirc::Test::Controller::Command::Chan.kick({chan, chan2}, target).should eq("KICK #patate,#nyu nyupnyup")
    Crirc::Test::Controller::Command::Chan.kick({chan}, {target, target2}).should eq("KICK #patate nyupnyup,gloubi")
    Crirc::Test::Controller::Command::Chan.kick(chan, {target, target2}).should eq("KICK #patate nyupnyup,gloubi")
    Crirc::Test::Controller::Command::Chan.kick({chan, chan2}, {target, target2}).should eq("KICK #patate,#nyu nyupnyup,gloubi")
    Crirc::Test::Controller::Command::Chan.kick({chan, chan2}, {target, target2}, "Get out").should eq("KICK #patate,#nyu nyupnyup,gloubi :Get out")
    Crirc::Test::Controller::Command::Chan.kick({chan}, {target}, "Get out").should eq("KICK #patate nyupnyup :Get out")
    Crirc::Test::Controller::Command::Chan.kick(chan, target, "Get out").should eq("KICK #patate nyupnyup :Get out")
  end
end
