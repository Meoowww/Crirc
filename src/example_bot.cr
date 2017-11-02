require "./crirc"

private def bind_example(bot)
  bot.on("JOIN") do |msg|
    if msg.source == bot.nick
      bot.puts "hello world!"
    end
  end.on("PING") do |msg|
    #bot.pong(msg.message)
    bot.puts(msg.message)
  end.on("PRIVMSG", message: /^!ping */) do |msg|
    #bot.reply(msg, "pong #{msg.source}")
    bot.puts("pong #{msg.source}")
  end.on_ready do
    #bot.join("#equilibre")
    bot.puts("#equilibre")
  end
end

client = Crirc::Network::Client.new "Crircbot", "irc.mozilla.org", 6667, ssl: false
client.connect
client.start do |bot|
  bind_example bot
  loop do
    begin
      m = bot.gets
      break if m.nil?
      spawn {bot.handle(m.as(String))}
    rescue error
      puts error
      sleep 0.1
    end
  end
end

client.close
