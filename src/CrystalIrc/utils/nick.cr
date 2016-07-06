module CrystalIrc
  # Represent a Nick for Irc Clients
  class Nick
    @base : String
    @suffix : UInt16?

    getter base

    def initialize(base)
      @base = "*"
      self.base = base
    end

    def reset
      @suffix = nil
      self
    end

    def base=(v) : String
      reset
      raise ParsingError.new "user name must contains at most 50 valid characters" if !v.match(/\A(?!.{51,})(([a-zA-Z])([a-zA-Z0-9_\-\[\]\\\`\^\{\}]*))\Z/)
      @base = v
    end

    def next : String
      @suffix ||= 0_u16
      @suffix = (@suffix.as(UInt16)) + 1_u16
      to_s
    end

    def suffix : String
      @suffix ? "_#{@suffix}" : ""
    end

    def to_s : String
      base + suffix
    end
  end
end
