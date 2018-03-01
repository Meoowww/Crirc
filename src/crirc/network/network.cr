# A `Network` is controlling a I/O.
# It is in charge to manage TCP messages at the TCP protocol level.
module Crirc::Network
  # Interface implemented by every `Crirc::Network`.
  module Network
    abstract def puts(data)
    abstract def gets
  end
end
