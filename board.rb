require './cell.rb'

class Board

	attr_reader :number_solved

	def initialize
		@cells = Array.new(9)
		@number_solved = 0
  	for i in 0..8 do
  		@cells[i] = Array.new(9)
      for j in 0..8
      	@cells[i][j] = Cell.new(:row => i, :column => j)
	    end
  	end
  end

  def set_cell(row, column, value)
  	cell = @cells[row][column]
  	return if cell.solved?
  	cell.set_value value
  	@number_solved += 1

  	get_couples_for_cell(cell).each do |c|
  		c.remove_candidate(value)
  	end
  end

  def resolve_singleton_candidates
  	@cells.flatten.each do |c|
  		next if c.solved?
  		candidates = c.candidates
  		set_cell(c.row, c.column, candidates[0]) if candidates.length == 1
  	end
  end

  def to_s
  	top_tail = '  +-------+-------+-------+'
  	str = ""
  	@cells.each_index do |i|  		
	  	str += "\n#{top_tail}" if (i % 3 == 0)
	  	str += "  solved: #{@number_solved}" if i == 0
	  	str += "\n#{i+1} "
  		@cells[i].each_index do |j|
  		str += "| " if (j % 3 == 0)
  			str += "#{@cells[i][j]} "
  		end
  		str += '|'
  	end
  	str + "\n#{top_tail}\n"
  end

  def solve
  	while true do
	  	number_solved_before = @number_solved
	  	resolve_singleton_candidates
	  	break if number_solved_before == @number_solved
	  end
  end

  private
  
  def get_couples_for_cell(cell)
 		row = get_couples_in_row_for_cell(cell)
 		col = get_couples_in_column_for_cell(cell)
  	block = get_couples_in_block_for_cell(cell)

  	(row + col + block).uniq.sort
  end

 	def get_couples_in_row_for_cell(cell)
  	@cells[cell.row].reject { |c| c === cell }
  end

  def get_couples_in_column_for_cell(cell)
 		cells = []
  	row = cell.row
  	column = cell.column

  	for i in 0..8 do
  		cells << @cells[i][column] unless i == row
  	end

  	cells
  end

  def get_couples_in_block_for_cell(cell)
  	left_edge = find_block_edge(cell.column)
  	top_edge = find_block_edge(cell.row)
  	cells = []

  	for i in top_edge..(top_edge + 2)
  		for j in left_edge..(left_edge + 2)
  			cells << @cells[i][j] unless @cells[i][j] === cell
  		end
 		end

  	cells
  end

  def find_block_edge(index)
  	(index / 3) * 3
  end
end
