# The Crirc module contains all the object related to the project.
# It uses 4 layers of objects:
#
# 1. **Network**: A network object manage a socket / I0.
#    The interface is described by `Crirc::Network::Network`.
# 2. **Controller**: A controller belongs to a network object,
#    and handle the logic and data. Its interface is described by
#    `Crirc::Controller::Controller`.
# 3. **Protocol**: A protocol object represent a IRC entity
#    (chan, user, message, ...).
# 4. **Broadcast**: The `Broadcast` allows the system to send transmission to
#    several IRC entity as one.
# 5. **Binding**: The `Binding::Handler` allows a given `Controller` to respond
#    to incoming transmissions.
module Crirc
end

require "./crirc/network/*"
require "./crirc/controller/*"
require "./crirc/protocol/*"
require "./crirc/broadcast/*"
require "./crirc/binding/*"
