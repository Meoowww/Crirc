module CrystalIrc
  abstract class HasSocket
    abstract def close
    abstract def closed?
    abstract def gets
    abstract def puts
  end
end
