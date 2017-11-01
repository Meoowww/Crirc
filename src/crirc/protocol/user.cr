require "./target"

# A User repretents a IRC client.
#
# It has a nick, id and whois.
class Crirc::Protocol::User < Crirc::Protocol::Target
  property nick : String
  getter id : String
  getter whois : String?

  CHARS_SPECIAL = "[_\\|\\[\\]\\\\\\`\\^\\{\\}]"
  CHARS_ALPHA   = "[a-zA-Z]"
  CHARS_NUM     = "[0-9\\-]"
  CHARS_FIRST   = "#{CHARS_SPECIAL}|#{CHARS_ALPHA}"
  CHARS_NEXT    = "#{CHARS_FIRST}|#{CHARS_NUM}"

  def initialize(@nick, id = nil, @whois = nil)
    raise ParsingError.new "The user nick (#{@nick}) must not be empty" if @nick.empty?
    raise ParsingError.new "The user nick (#{@nick}) must contains at most 50 valid characters" if !@nick.match(/\A(?!.{51,})((#{CHARS_FIRST})((#{CHARS_NEXT})+))\Z/)
    @id = id || @nick
  end

  def self.parse(source : String) : User
    m = source.match(/\A:?(?<name>[^!]+)!(?<id>.+)@(?<whois>.+)\Z/)
    raise ParsingError.new "The source (#{source}) is not a valid user" if m.nil?
    User.new m["name"], m["id"], m["whois"]
  end

  def name : String
    @nick
  end

  class ParsingError < Exception; end
end
