class CrystalIrc::Bot
  def join(*chan_names : String)
    self.join chan_names.map { |chan_name| Chan.new chan_name }
  end
end
