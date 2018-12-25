# The module `Command` is the scope for the IRC commands
# defined in the standard.
# Each of these commands is included by a `Controller`, so the `puts` function
# is implemented by the `Controller`.
module Crirc::Controller::Command
  abstract def puts(data)
end
