module CrystalIrc
  class Client

    class Nick

      @base   : String
      @suffix : UInt16?

      getter base

      def initialize(@base)
      end

      def reset!
        @base = ""
        @suffixed = nil
        self
      end

      def base=(v) : String
        reset!
        @base = v
      end

      def next : String
        @suffix ||= 0_u16
        @suffix = (@suffix as UInt16) + 1_u16
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
end
