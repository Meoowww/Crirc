# A target is a virtuel IRC entity that can receive message (`User`, `Chan`).
abstract class Crirc::Protocol::Target
  abstract def name : String
end
