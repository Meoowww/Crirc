require "fast_irc"

# Contains the classes that handle the network layer.
# They establish the connexion, fetch and send the messages data, etc.
module Crirc::Network
end
require "./crirc/network/*"

# Contains the logic of the irc client or server (initialisation, authentication, etc.).
# a Controller is created by a Network object.
module Crirc::Controller
end
require "./crirc/controller/*"

# Contains atomic elements such as Chan, User, or Message.
# Those can be used to interact with the `Crirc::Command` modules and `Crirc::Binding`.
module Crirc::Protocol
end
require "./crirc/protocol/*"

require "./crirc/broadcast/*"
require "./crirc/binding/*"
