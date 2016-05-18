require "./CrystalIrc"

def start
  bot = CrystalIrc::Bot.new ip: "irc.mozilla.org", nick: "Dash", read_timeout: 30_u16
  chan = CrystalIrc::Chan.new("#ponytown")

  bot.on("JOIN") do |irc, msg|
    name = msg.source.split("!").first
    irc.privmsg(chan, "Welcome everypony, what's up #{name} ? :)") unless name == bot.nick.to_s
  end

  bot.connect
  sleep 1
  bot.join([chan])

  loop do
    begin
      bot.gets do |m|
        break if m.nil?
        puts m
        spawn { bot.handle(m as String) }
      end
    rescue IO::Timeout
      puts "Nothing happened..."
    end
  end
end

start
