module CrystalIrc

  class User

    @name   : String
    @client : CrystalIrc::Client

    def initialize(@name, @client)
    end

    def send(message : String)
      @client.puts(@name, message)
    end
  end

end
