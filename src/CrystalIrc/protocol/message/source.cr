module CrystalIrc
  # Extention of `String`.
  module Source
    def source_nick : String
      self.split("!")[0].to_s
    end

    def source_id : String
      self.split("!")[1].to_s.split("@")[0].to_s
    end

    def source_whois : String
      self.split("!")[1].to_s.split("@")[1].to_s
    end
  end
end

class String
  include CrystalIrc::Source
end
