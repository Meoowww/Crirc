require "./crirc"

private def bind_example(bot)
  bot.on("JOIN") do |msg|
    if msg.source == bot.nick
      bot.send "hello world!"
    end
  end.on("PING") do |msg|
    bot.pong(msg.message)
  end.on("PRIVMSG", message: /^!ping */) do |msg|
    bot.reply(msg, "pong #{msg.source}")
  end.on_ready do
    bot.join("#equilibre")
  end
end

client = Crirc::Network::Client.new "irc.mozilla.org", 6667
client.connect
client.start do |bot|
  bind_example bot
  loop do
    begin
      m = bot.gets
      break if m.nil?
      spawn bot.handle(m)
    rescue => error
      puts error
      sleep 0.1
    end
  end
end

client.close
