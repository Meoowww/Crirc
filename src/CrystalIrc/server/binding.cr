# Default binding on the server.
# Handles the classic behavior of a server.
module CrystalIrc::Server::Binding
  def self.attach(obj)
    obj.on("PING") do |msg|
      msg.sender.pong(msg.message)
    end
  end
end

# .on("JOIN") do |msg|
#   chans = msg.raw_arguments.to_s.split(",").map { |e| CrystalIrc::Chan.new e.strip }
#   # TODO: create the chan if needed
#   # TODO: add the user the the chans
#   # TODO: send to the chans
#   # TODO: use something like msg.sender.user instead of "user"
#   chans.each { |chan| msg.sender.notice CrystalIrc::User.new("user"), "JOINED #{chan.name}" }
# end
