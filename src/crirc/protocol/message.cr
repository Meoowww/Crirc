class Crirc::Protocol::Message
  getter raw : String
  getter source : String
  getter command : String
  getter arguments : String?
  getter message : String?

  R_SRC     = "(\\:(?<src>[^[:space:]]+) )"
  R_CMD     = "(?<cmd>[A-Z]+|\\d{3})"
  R_ARG_ONE = "(?:[^: ][^ ]*)"
  R_ARG     = "(?: (?<arg>#{R_ARG_ONE}(?: #{R_ARG_ONE})*))"
  R_MSG     = "(?: \\:(?<msg>.+)?)"

  def initialize(@raw)
    m = raw.strip.match(/\A#{R_SRC}?#{R_CMD}#{R_ARG}?#{R_MSG}?\Z/)
    raise ParsingError.new(@raw, "message invalid") if m.nil?
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

  def arguments : Array(String)
    return Array(String).new if @arguments.nil? && @message.nil?
    return (@arguments.as(String)).split(" ") if @message.nil?
    return [@message.as(String)] if @arguments.nil?
    return (@arguments.as(String)).split(" ") << (@message.as(String))
  end
end
