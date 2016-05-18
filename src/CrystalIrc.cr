require "socket"
require "./CrystalIrc/*"

module CrystalIrc

  class IrcError < Exception; end
  class NotImplemented < IrcError; end
  class NoConnection < IrcError; end

  class InvalidMessage < IrcError; end
  class InvalidName < CrystalIrc::IrcError; end
  class InvalidChanName < CrystalIrc::InvalidName; end
  class InvalidUserName < CrystalIrc::InvalidName; end
  class InvalidNick < CrystalIrc::InvalidName; end

end
