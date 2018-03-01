# A `Controller` is controlling a `Network`.
# It is in charge to manage IRC messages at the IRC protocol level.
module Crirc::Controller::Controller
  abstract def puts(data)
  abstract def gets
end
