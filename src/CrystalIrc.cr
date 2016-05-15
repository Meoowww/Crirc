require "socket"
require "./CrystalIrc/*"

module CrystalIrc
  class IrcError < Exception; end
  class NotImplemented < IrcError; end
  class NoConnection < IrcError; end
end
