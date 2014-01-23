require 'test/unit'
require './cell.rb'


class CellTest < Test::Unit::TestCase

  def test_cell_value_is_initially_null
    assert_nil Cell.new.value
  end

  def test_can_set_cell_value
    c = Cell.new
    c.set_value 4
    assert_equal 4, c.value
  end

  def test_cell_candidates_are_initially_everything
    assert_equal [1, 2, 3, 4, 5, 6, 7, 8, 9], Cell.new.candidates
  end

  def test_cell_with_value_has_no_candidates
    c = Cell.new
    c.set_value 4
    assert_equal [], c.candidates
  end

  def test_can_get_cell_row
    assert_equal 2, Cell.new(:row => 2).row
  end

  def test_can_get_cell_column
    assert_equal 5, Cell.new(:column => 5).column
  end

  def test_cells_sort_by_row
    c1 = Cell.new(:row => 1)
    c2 = Cell.new(:row => 2)

    assert((c1 <=> c2) < 0)
    assert((c2 <=> c1) > 0)
  end

  def test_cells_sort_by_column
    c1 = Cell.new(:row => 1, :column => 1)
    c2 = Cell.new(:row => 1, :column => 2)

    assert((c1 <=> c2) < 0)
    assert((c2 <=> c1) > 0)

    c2 = Cell.new(:row => 1, :column => 1)
    assert((c1 <=> c2) == 0)
  end

  def test_cell_can_remove_a_candidate
    c = Cell.new

    c.remove_candidate(3)
    assert_equal [1, 2, 4, 5, 6, 7, 8, 9], c.candidates

    c.remove_candidate(5)
    assert_equal [1, 2, 4, 6, 7, 8, 9], c.candidates

    c.remove_candidate(8)
    assert_equal [1, 2, 4, 6, 7, 9], c.candidates
  end

  def test_cell_will_tell_me_if_it_is_not_solved
    assert !(Cell.new().solved?)
  end

  def test_cell_will_tell_me_if_it_is_solved
    c = Cell.new()
    c.set_value 5
    assert c.solved?
  end

end
