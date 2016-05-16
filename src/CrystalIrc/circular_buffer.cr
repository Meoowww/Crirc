module CrystalIrc

  @strings : Array(String)

  class CircularBuffer < Array(String)

    def next : String
      str = self.shift
      self << str
      str
    end

  end
end
