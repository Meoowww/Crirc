module CrystalIrc::Command::Talk
  # Send a notice to the given target.
  def notice(target : CrystalIrc::Target, msg : String)
    answer_raw "NOTICE #{target.name} :#{msg}"
  end

  # Send a private message to the given target.
  def privmsg(target : CrystalIrc::Target, msg : String)
    answer_raw "PRIVMSG #{target.name} :#{msg}"
  end
end
