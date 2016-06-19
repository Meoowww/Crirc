require "socket"

module CrystalIrc
  alias IrcSocket = (TCPSocket | OpenSSL::SSL::Socket)

  class IrcError < Exception; end
  class NotImplemented < IrcError; end
  class NoConnection < IrcError; end

  class InvalidMessage < IrcError; end
  class InvalidName < CrystalIrc::IrcError; end
  class InvalidChanName < CrystalIrc::InvalidName; end
  class InvalidUserName < CrystalIrc::InvalidName; end
  class InvalidUserSource < CrystalIrc::InvalidName; end
  class InvalidNick < CrystalIrc::InvalidName; end

end

require "./CrystalIrc/utils/*"
require "./CrystalIrc/protocol/*"
require "./CrystalIrc/*"
