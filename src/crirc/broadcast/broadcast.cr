# Allow to send data to several IRC entity as one.
module Crirc::Broadcast
  # TODO
  abstract def puts(context : Controller::Controller, data)
end
