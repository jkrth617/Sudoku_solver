require 'pry'

class Sudoku

  attr_accessor :board
  attr_reader :blank_space

  def initialize(board_string)
    @board = board_string.chars
    @blank_space = "-"        
  end

  def solve_game
    self.board = solver(board, 0)
  end

  def solver(my_board, depth)
    return false unless valid?(my_board)
    return board if solved?(my_board)
    i, poss_array = get_cell_with_lowest_choices(my_board)
    poss_array.each do |try|
      my_board[i] = try
      # display_while_running
      recursive_solved_board = solver(my_board, depth+1)
      return recursive_solved_board if recursive_solved_board
      my_board[i] = blank_space
    end
    return false
  end

  def get_cell_with_lowest_choices(my_board)
    choices_collection = []
    my_board.each_with_index do |value, index|
      if value == blank_space
        pos = my_possibilities(index, my_board)
        choices_collection << [pos.count, index, pos]
      end
    end
    choices_collection.sort.first[1..2]
  end

  def my_possibilities(index, my_board)
    ("1".."9").to_a - (row_taken_numbers(index, my_board) + col_taken_numbers(index, my_board) + box_taken_numbers(index, my_board)).uniq
  end

  def valid?(working_board)
    (0..8).to_a.each do |index|
      row_check = row_taken_numbers(index, working_board).length == row_taken_numbers(index, working_board).uniq.length 
      col_check = col_taken_numbers(index, working_board).length == col_taken_numbers(index, working_board).uniq.length 
      box_check = box_taken_numbers(index, working_board).length == box_taken_numbers(index, working_board).uniq.length
      return false unless row_check && col_check && box_check 
    end
    return true
  end

  def solved?(working_board)
    !working_board.include?(blank_space)
  end

  def row_taken_numbers(i, working_board)
    working_board = working_board.each_slice(9).to_a
    working_board[index_to_row(i)].reject{|cell| cell == blank_space}
  end

  def col_taken_numbers(i, working_board)
    working_board = working_board.each_slice(9).to_a
    working_board.transpose[index_to_col(i)].reject{|cell| cell == blank_space}
  end

  def box_taken_numbers(i, working_board)
    boxify(working_board)[index_to_box(i)].reject{|cell| cell == blank_space}
  end

  def boxify(working_board)
    modified_board = Array.new(9) { Array.new() }
    working_board.each_with_index do |cell, index|
      modified_board[index_to_box(index)]<<cell
    end
    modified_board
  end

  def index_to_row(index)
    index/9
  end

  def index_to_col(index)
    index%9
  end

  def index_to_box(index)
    (index/3)%3 + 3*((index/9)/3)
  end

  def to_s()
    return "Invalid board, double check" if board == false
    nested = board.each_slice(9)
    nested.map{|row| row.join(" | ")}.join("\n")
  end

  def display_while_running
    print "\e[2J"
    print "\e[H"
    puts self
    sleep 0.1
  end

end


# game_easy = Sudoku.new("1-58-2----9--764-52--4--819-19--73-6762-83-9-----61-5---76---3-43--2-5-16--3-89--")
# game_medium = Sudoku.new("-3-5--8-45-42---1---8--9---79-8-61-3-----54---5------78-----7-2---7-46--61-3--5--")
# game_hard = Sudoku.new("----------2-65-------18--4--9----6-4-3---57-------------------73------9----------")
# game_blank = Sudoku.new("---------------------------------------------------------------------------------")
game_wtf = Sudoku.new("8----------36------7--9-2---5---7-------457-----1---3---1----68--85---1--9----4--")
# binding.pry
