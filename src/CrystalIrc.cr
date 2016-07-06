require "socket"

module CrystalIrc
  alias IrcSocket = (TCPSocket | OpenSSL::SSL::Socket)
  alias IrcServer = (TCPServer | OpenSSL::SSL::Socket::Server)

  class IrcError < Exception; end

  class NotImplementedError < IrcError; end

  class NetworkError < IrcError; end

  class ParsingError < IrcError
    def initialize(str : String, msg : String? = nil)
      super("Cannot parse \"#{str}\"" + (msg ? " #{msg}" : ""))
    end
  end
end

require "./CrystalIrc/utils/*"
require "./CrystalIrc/protocol/*"
require "./CrystalIrc/*"
