require "./target"

# Representation of an IRC client.
#
# It has a name (or nick), id (id@...) and an optionaly a whois.
#
# It does not represent a controllable client (only the class `Client` does).
# TODO: checkout the masks
class CrystalIrc::User < CrystalIrc::Target
  @nick : String
  @id : String
  @whois : String?

  getter nick, id, whois

  CHARS_SPECIAL = "[_\\|\\[\\]\\\\\\`\\^\\{\\}]"
  CHARS_ALPHA = "[a-zA-Z]"
  CHARS_NUM = "[0-9\\-]"
  CHARS_FIRST = "#{CHARS_SPECIAL}|#{CHARS_ALPHA}"
  CHARS_NEXT = "#{CHARS_FIRST}|#{CHARS_NUM}"
  def initialize(@nick, id = nil, @whois = nil)
    raise ParsingError.new @nick, "user name must not be empty" if @nick.empty?
    raise ParsingError.new @nick, "user name must contains at most 50 valid characters" if !@nick.match(/\A(?!.{51,})((#{CHARS_FIRST})((#{CHARS_NEXT})+))\Z/)
    @id = id || @nick
  end

  def self.parse(source : String) : User
    m = source.match(/\A:?(?<name>[^!]+)!(?<id>.+)@(?<whois>.+)\Z/)
    raise ParsingError.new source, "invalid user" if m.nil?
    CrystalIrc::User.new(m["name"], m["id"], m["whois"])
  end

  def name : String
    @nick
  end
end
