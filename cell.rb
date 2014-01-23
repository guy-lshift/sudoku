class Cell
  def initialize()
  end

  attr_reader :row, :column, :value, :candidates

  def initialize(params = {})
    @row = params[:row]
    @column = params[:column]
    @candidates = [1, 2, 3, 4, 5, 6, 7, 8, 9]
  end

  def set_value(v)
    @value = v
    @candidates = []
  end

  def <=>(other)
    return @column <=> other.column if @row == other.row
    @row <=> other.row
  end

  def remove_candidate(candidate)
    @candidates.reject! { |c| c == candidate}
  end

  def solved?
    @value != nil
  end

  def to_s
    return ' ' if @value == nil
    return @value.to_s
  end
end
