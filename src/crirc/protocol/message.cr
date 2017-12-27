# Message is a class that handles the data sent through the network.
# It is parsed to provide access to specific parts of the data.
class Crirc::Protocol::Message
  # The raw data without parsing
  getter raw : String

  # The source of the message (ex: uuidxxx@moz-stuff.net)
  getter source : String

  # The command / response (ex: PRIVMSG or 535)
  getter command : String

  # The arguments (not parsed) as a simple string. If there are no arguments in
  # the message, then it is nil
  getter arguments : String?

  # The last argument of the message if it begins with :, or nil if none.
  getter message : String?

  R_SRC     = "(\\:(?<src>[^[:space:]]+) )"
  R_CMD     = "(?<cmd>[A-Z]+|\\d{3})"
  R_ARG_ONE = "(?:[^: ][^ ]*)"
  R_ARG     = "(?: (?<arg>#{R_ARG_ONE}(?: #{R_ARG_ONE})*))"
  R_MSG     = "(?: \\:(?<msg>.+)?)"

  def initialize(@raw)
    m = raw.strip.match(/\A#{R_SRC}?#{R_CMD}#{R_ARG}?#{R_MSG}?\Z/)
    raise ParsingError.new "The message (#{@raw}) is invalid" if m.nil?
    @source = m["src"]? || "0"
    @command = m["cmd"] # ? || raise InvalidMessage.new("No command to parse in \"#{raw}\"")
    @arguments = m["arg"]?
    @message = m["msg"]?
  end

  # Concatenation of `arguments` and `message`. If the message exists, it is preceded by ':'
  def raw_arguments : String
    return "" if @arguments.nil? && @message.nil?
    return @arguments.to_s if @message.nil?
    return ":#{@message}" if @arguments.nil?
    return "#{@arguments} :#{@message}"
  end

  # The list of the arguments parsed as an Array of String. Empty if no arguments
  def argument_list : Array(String)
    return Array(String).new if @arguments.nil? && @message.nil?
    return (@arguments.as(String)).split(" ") if @message.nil?
    return [@message.as(String)] if @arguments.nil?
    return (@arguments.as(String)).split(" ") << (@message.as(String))
  end

  class ParsingError < Exception; end
end
