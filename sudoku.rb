#! /usr/bin/ruby
require './board.rb'

class Game

	def initialize
		@board = Board.new
@cell55 = @board.instance_variable_get(:@cells)[4][4]
	end

	def output_cta
		puts "X Y Z: row, column, value [1-9] separated by spaces to set a cell"
		puts "X ABCDEFGHI: a digit [1-9] for row number followed by 9 digits [0-9]"
		puts "x to quit"
	end

	def get_input
		input = gets.chomp

		if input == 'x'
			return false 
		elsif input =~ /^([1-9])\s+([1-9])\s+([1-9])$/
			add_cell($1, $2, $3)
		elsif input =~ /^([0-9])\s+([0-9]{9})$/
			add_row($1, $2)
		end

		puts @board
		true
	end

	def add_cell(row_digit, column_digit, value_digit)
		@board.set_cell(row_digit.to_i - 1, column_digit.to_i - 1, value_digit.to_i)
		@board.solve
	end

	def add_row(row_digit, value_string)
		row = row_digit.to_i - 1
		values = value_string.chars.map { |v| v.to_i }
		values.each_index do |i|
			value = values[i]
			@board.set_cell(row, i, value) if value != 0
		end
		@board.solve
	end

	def play
		begin
			output_cta
		end while get_input == true
	end

end

Game.new.play
