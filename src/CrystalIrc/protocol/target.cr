# A Target is a virtual entity to represent something a client can talk with.
# In pratice, this is any entity with a name, which includes:
# - `User`
# - `Chan`
abstract class CrystalIrc::Target
  abstract def name : String
end
