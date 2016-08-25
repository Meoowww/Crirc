require "./message/*"

# This class is an entity to represent an IRC message.
#
# Every message has a sender and a command (or a code).
# Optionaly, it may have a source, arguments, and message.
#
# **Rules**
# - If no source is specified, then it will be set to "0" by default.
# - The attribute `message` is used to represent the last argument if begin with a ':'. It it does not exist, then it will be considered `Nil`
# - If no arguments are specified, then it will be an empty `Array(String)`. *Note: if the last one (the message) begin with a ':', then the ':' is deleted from the string.*
# - The raw_arguments is the concatenation of arguments and message. *Note: The message, if exists, is always preceded by ':'
class CrystalIrc::Message
  @raw : String
  @source : String
  @command : String
  @arguments : String?
  @message : String?
  @sender : CrystalIrc::IrcSender

  getter raw, source, command, message, sender

  # Concatenation of `arguments` and `message`. If the message exists, it is preceded by ':'
  def raw_arguments : String
    return "" if @arguments.nil? && @message.nil?
    return @arguments.to_s if @message.nil?
    return ":#{@message}" if @arguments.nil?
    return "#{@arguments} :#{@message}"
  end

  def arguments : Array(String)
    return Array(String).new if @arguments.nil? && @message.nil?
    return (@arguments.as(String)).split(" ") if @message.nil?
    return [@message.as(String)] if @arguments.nil?
    return (@arguments.as(String)).split(" ") << (@message.as(String))
  end

  R_SRC     = "(\\:(?<src>[^[:space:]]+) )"
  R_CMD     = "(?<cmd>[A-Z]+|\\d{3})"
  R_ARG_ONE = "(?:[^: ][^ ]*)"
  R_ARG     = "(?: (?<arg>#{R_ARG_ONE}(?: #{R_ARG_ONE})*))"
  R_MSG     = "(?: \\:(?<msg>.+))"

  def initialize(@raw, @sender)
    m = raw.strip.match(/\A#{R_SRC}?#{R_CMD}#{R_ARG}?#{R_MSG}?\Z/)
    raise ParsingError.new(raw, "message invalid") if m.nil?
    @source = m["src"]? || "0"
    @command = m["cmd"] # ? || raise InvalidMessage.new("No command to parse in \"#{raw}\"")
    @arguments = m["arg"]?
    @message = m["msg"]?
  end

  delegate source_nick, to: source
  delegate source_id, to: source
  delegate source_whois, to: source

  def hl : String
    self.source_nick
  end

  CHAN_COMMANDS = ["PRIVMSG", "JOIN", "NOTICE"]

  # TODO: if a chan is associated (eg: message emit in a chan)
  def chan : Chan
    if CHAN_COMMANDS.includes?(@command) && !arguments.empty? && arguments[0][0] == '#'
      Chan.new arguments[0]
    else
      raise NotImplementedError.new "No chan availiable"
    end
  end

  USER_COMMANDS = ["PRIVMSG", "NOTICE"]

  # TODO: if an user is associated (eg: privmsg, ...)
  def user : User
    if USER_COMMANDS.includes?(@command) && !arguments.empty? && arguments[0][0] != '#'
      User.new arguments[0]
    else
      raise NotImplementedError.new "No user availiable"
    end
  end

  # Channel or User which emit the message
  def target : Target
    user rescue chan rescue raise NotImplementedError.new "No chan nor user availiable"
  end

  # Target to reply
  def reply_to : Target
    begin
      chan rescue User.parse(@source)
    rescue e
      STDERR.puts e
      raise NotImplementedError.new "No chan nor user to reply"
    end
  end

  def reply(msg : String) : Message
    @sender.privmsg(reply_to, msg)
    self
  end
end
