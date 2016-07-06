require "./CrystalIrc"

def start
  bot = CrystalIrc::Bot.new ip: "irc.mozilla.org", nick: "Dashy", read_timeout: 30_u16
  chan = CrystalIrc::Chan.new("#equilibre2")

  bot.on("JOIN") do |msg|
    name = msg.source.to_s.split("!").first
    if name == bot.nick.to_s
      bot.privmsg(chan, "Welcome everypony, what's up ? :)")
    else
      bot.privmsg(chan, "Welcome everypony, what's up #{name} ? :)")
    end
  end.on("PING") do |msg|
    STDERR.puts "PONG :#{msg.message}"
    bot.pong(msg.message)
  end.on("PRIVMSG", message: /^(hi|hello|heil|y(o|u)(p?)|salut)/i) do |msg|
    name = msg.source.to_s.split("!").first
    curr_chan = CrystalIrc::Chan.new(msg.raw_arguments.as(String))
    bot.privmsg(curr_chan, "Hi #{name} :)")
  end.on("PRIVMSG", message: /^!ping/) do |msg|
    name = msg.source.to_s.split("!").first
    curr_chan = CrystalIrc::Chan.new(msg.raw_arguments.as(String))
    bot.privmsg(curr_chan, "pong #{name}")
  end

  bot.connect
  sleep 1
  bot.join([chan])

  loop do
    begin
      bot.gets do |m|
        break if m.nil?
        puts m
        spawn { bot.handle(m.as(String)) }
      end
    rescue IO::Timeout
      puts "Nothing happened..."
    end
  end
end

start
