require 'test/unit'
require './board.rb'
require './cell.rb'


class BoardTest < Test::Unit::TestCase

  def setup
    @board = Board.new
  end
  
  def test_new_board_has_81_cells
    cells = @board.cells
    assert_equal 81, cells.flatten.length
  end

  def test_board_identifies_8_couples_in_row
    cell = @board.cells[3][5]
    couples = @board.send(:get_couples_in_row_for_cell, cell)


    cells = @board.cells
    expected = [
      cells[3][0], cells[3][1], cells[3][2],
      cells[3][3], cells[3][4],
      cells[3][6], cells[3][7], cells[3][8],
    ]

    assert_equal expected, couples
  end

  def test_board_identifies_8_couples_in_column
    cell = @board.cells[3][5]
    couples = @board.send(:get_couples_in_column_for_cell, cell)


    cells = @board.cells
    expected = [
      cells[0][5], cells[1][5], cells[2][5],
      cells[4][5], cells[5][5], cells[6][5], cells[7][5], cells[8][5],
    ]

    assert_equal expected, couples
  end

  def test_board_finds_0_block_edge_for_0_index
    assert_equal 0, @board.send(:find_block_edge, 0)
  end

  def test_board_finds_3_block_edge_for_3_index
    assert_equal 3, @board.send(:find_block_edge, 3)
  end

  def test_board_finds_0_block_edge_for_2_index
    assert_equal 0, @board.send(:find_block_edge, 2)
  end

  def test_board_finds_6_block_edge_for_8_index
    assert_equal 6, @board.send(:find_block_edge, 8)
  end

  def test_board_identifies_8_couples_in_block
    cell = @board.cells[3][5]
    couples = @board.send(:get_couples_in_block_for_cell, cell)

    cells = @board.cells
    expected = [
      cells[3][3], cells[3][4],
      cells[4][3], cells[4][4], cells[4][5],
      cells[5][3], cells[5][4], cells[5][5],
    ]

    assert_equal expected, couples
  end

  def test_board_identifies_8_couples_in_non_diagonal_block
    cell = @board.cells[0][3]
    couples = @board.send(:get_couples_in_block_for_cell, cell)

    cells = @board.cells
    expected = [
      cells[0][4], cells[0][5],
      cells[1][3], cells[1][4], cells[1][5],
      cells[2][3], cells[2][4], cells[2][5],
    ]

    assert_equal expected, couples
  end

  def test_board_identifies_20_couples
    cell = @board.cells[3][5]
    couples = @board.send(:get_couples_for_cell, cell)

    cells = @board.cells
    expected = [
      cells[0][5], cells[1][5], cells[2][5],
      cells[3][0], cells[3][1], cells[3][2],
      cells[3][3], cells[3][4],
      cells[3][6], cells[3][7], cells[3][8],
      cells[4][3], cells[4][4], cells[4][5],
      cells[5][3], cells[5][4], cells[5][5],
      cells[6][5], cells[7][5], cells[8][5],
    ]

    assert_equal expected, couples
  end

  def test_board_can_set_cell_value
    @board.set_cell(2, 3, 4)
    assert_equal 4, @board.cells[2][3].value
  end

  def test_setting_a_cell_clears_coupled_candidates
    @board.set_cell(5, 6, 7)
    cell = @board.cells[5][6]
    couples = @board.send(:get_couples_for_cell, cell)

    couples.each do |c|
      assert_equal [1, 2, 3, 4, 5, 6, 8, 9], c.candidates, "found a candidate 7 in cell [#{c.row}][#{c.column}]"
    end 
  end

  def test_board_resolves_singleton_candidates
    cells = @board.cells
    cell = cells[4][7]
    cell.candidates = [5]

    @board.resolve_singleton_candidates
    assert_equal 5, cell.value
  end

  def test_resolving_singleton_candidate_clears_coupled_candidates
    cell = @board.cells[4][7]
    cell.candidates = [2]

    @board.resolve_singleton_candidates

    couples = @board.send(:get_couples_in_block_for_cell, cell)
    couples.each do |c|
      assert_equal [1, 3, 4, 5, 6, 7, 8, 9], c.candidates
    end
  end

  def test_board_wont_alter_cell_with_value
    @board.set_cell(1, 2, 3)
    @board.set_cell(1, 2, 4)
    assert_equal 3, @board.cells[1][2].value
  end

  def test_board_knows_how_many_cells_solved
    assert_equal 0, @board.number_solved

    @board.set_cell(1, 2, 3)
    assert_equal 1, @board.number_solved

    @board.set_cell(2, 2, 3)
    assert_equal 2, @board.number_solved

    @board.set_cell(2, 2, 4)
    assert_equal 2, @board.number_solved
  end

  def test_solve_resolves_singletons
    @board.cells[1][1].candidates = [8]
    @board.cells[4][5].candidates = [5]

    @board.solve

    assert_equal 8, @board.cells[1][1].value
    assert_equal 5, @board.cells[4][5].value
  end

  def test_solve_resolves_singletons_recursively
    @board.cells[1][1].candidates = [8]
    @board.cells[4][5].candidates = [5]
    @board.cells[4][1].candidates = [2, 5, 8]

    @board.solve

    assert_equal 2, @board.cells[4][1].value
  end


  private

  def assert_couple_cell_identity(params)
    index = params[:index]
    row = params[:row]
    col = params[:col]

    expected = params[:cells][row][col]
    actual = params[:couples][index]
    assert(expected === actual, "expected cell [#{expected.row},#{expected.column}] actual cell [#{actual.row},#{actual.column}]")
  end
end

class Board
  attr_reader :cells
end

class Cell
  attr_accessor :candidates
end