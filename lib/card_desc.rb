class CardDescLine
  attr_reader :name, :value

  def initialize(line)
    @line = line
    result = Hash[line.scan(/^(?!http)([^:]+)\s*:\s*(.+)$/i)]
    unless result.empty?
      result = result.map { |k, v| [k.parameterize.underscore.to_sym, v] }
      @name = result.first.first
      @value = result.first.second
    end
  end

  def value=(new_value)
    raise 'Trying to set value for a line without name param' if @name.blank?
    @need_rerender = true
    @value = new_value
  end

  def to_str
    if @need_rerender
      "#{@name.to_s.titleize}: #{@value}"
    else
      @line
    end
  end
end

class CardDesc
  def initialize(text)
    @lines ||= []
    @fields ||= {}
    @text = text
    text.split("\n").each { |line| add_line(line) }
  end

  def add_line(text_line)
    line = CardDescLine.new(text_line)
    @lines << line
    @fields[line.name] = line if line.name.present?
  end

  def [](field)
    read(field)
  end

  def []=(field, value)
    write(field, value)
  end

  def write(field, value)
    if @fields[field].present?
      @fields[field].value = value
    else
      field_name = field.to_s.titleize
      add_line("#{field_name}: #{value}")
    end
  end

  def read(field)
    @fields[field].present? ? @fields[field].value : nil
  end

  def to_str
    (@lines.map { |line| line.to_str }).join("\n")
  end

end