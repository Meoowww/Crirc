require "./CrystalIrc"

def start
  bot = CrystalIrc::Bot.new ip: "irc.mozilla.org", nick: "Dash", read_timeout: 30_u16
  chan = CrystalIrc::Chan.new("#equilibre")

  bot.on("JOIN") do |msg|
    name = msg.source.to_s.split("!").first
    if name == bot.nick.to_s
      bot.privmsg(chan, "Welcome everypony, what's up ? :)")
    else
      bot.privmsg(chan, "Welcome everypony, what's up #{name} ? :)")
    end
  end.on("PING") do |msg|
    bot.pong(msg.arguments.to_s)
  end.on("PRIVMSG", message: /^(hi|hello|heil|y(o|u)(p?)|salut)/i) do |msg|
    name = msg.source.to_s.split("!").first
    curr_chan = CrystalIrc::Chan.new(msg.arguments_raw as String)
    bot.privmsg(curr_chan , "Hi #{name} :)")
  end.on("PRIVMSG", message: /^!ping/) do |msg|
    name = msg.source.to_s.split("!").first
    curr_chan = CrystalIrc::Chan.new(msg.arguments_raw as String)
    bot.privmsg(curr_chan , "pong #{name}")
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
