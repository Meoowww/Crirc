require "./crirc"


server = Crirc::Network::Server.new "0.0.0.0", 6667, ssl: false
server.start

client.close
