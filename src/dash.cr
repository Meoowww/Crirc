require "./CrystalIrc"

$verbose = true

module DashBot
  def start
    bot = CrystalIrc::Bot.new ip: "irc.mozilla.org", nick: "Dasshy", read_timeout: 300_u16

    bot.on("JOIN") do |msg|
      if msg.hl == bot.nick.to_s
        msg.reply "Welcome everypony, what's up ? :)"
      else
        STDERR.puts "[#{Time.now}] #{msg.hl} joined the chan"
      end
    end.on("PING") do |msg|
      bot.pong(msg.message)
    end.on("PRIVMSG", message: /^!ping/) do |msg|
      msg.reply "pong #{msg.hl} (#{msg.source.to_s.source_id})"
    end

    bot.connect.on_ready do
      bot.join("#equilibre")
    end

    loop do
      begin
        bot.gets do |m|
          break if m.nil?
          STDERR.puts "[#{Time.now}] #{m}"
          spawn { bot.handle(m.as(String)) }
        end
      rescue IO::Timeout
        puts "Nothing happened..."
      end
    end
  end

  extend self
end

DashBot.start
