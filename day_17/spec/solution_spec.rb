require 'aoc/helpers'

test_input = File.read('./test-input.txt')
real_input = get_input(2022, 17, File.read('/home/vscode/.adventofcode.session'))

part_1_expected = 3068
part_2_expected = 2

def parse_input(input)
	characters(input.strip)
end

def new_row
	['.'] * 7
end

def highest_rock(input)
	input.index(new_row) - 1
end

PIECES = [
	[['#']*4],
	[['.','#','.'], ['#']*3, ['.','#']],
	[['.','.','#'], ['.','.','#'], ['#']*3].reverse,
	[['#']]*4,
	[['#','#']]*2
]

def print_piece(piece)
	print piece.reverse.map(&:join).join("\n")
	puts
end

def piece_overlaps?(board, piece, loc)
	block_locs = []

	piece.each_with_index do|row, i|
		row.each_with_index do |val, j|
			if val == '#'
				block_locs << [loc[0] + j, loc[1] + i]
			end
		end
	end

	return block_locs.any? {|nloc| board[nloc[1]][nloc[0]] == '#'}
end

def place_piece(board, piece, loc, symbol = '#')
	piece.each_with_index do|row, i|
		row.each_with_index do |val, j|
			if val == '#'
				board[loc[1] + i][loc[0] + j] = symbol
			end
		end
	end
end

def push_block(piece, board, loc, direction)
	new_loc = loc.dup
	if direction == '<'
		return loc if loc[0] == 0
		new_loc[0] -= 1
	else
		max_index = piece.map do |row|
			row.rindex {|v| v == '#'}
		end.max
		return loc if loc[0] + max_index == 6
		new_loc[0] += 1
	end

	if piece_overlaps?(board, piece, new_loc)
		return loc
	end

	return new_loc
end

def print_board(board, piece = nil, loc = nil)
	height = highest_rock(board)

	b = board[0..(height + 10)].map(&:dup)

	if piece && loc
		place_piece(b, piece, loc, '@')
	end

	max_row = b.length

	b.reverse.each_with_index do |row, i|
		print row.join("")
		print "\n"
	end

end

def solution_part_1(input)
	input = parse_input(input)
	board = []
	board[0] = ['#']*7
	10_000.times do |i|
		board << new_row
	end

	current_piece = 0
	current_instruction = 0

	2022.times do
		piece = PIECES[current_piece%PIECES.length]

		loc = [2, highest_rock(board) + 4]

		loop do
			instruction = current_instruction%input.length
			current_instruction += 1
			new_loc = push_block(piece, board, loc, input[instruction])	

			loc = new_loc

			fall_loc = [loc[0], loc[1] - 1]

			break if piece_overlaps?(board, piece, fall_loc)
			loc = fall_loc
		end

		place_piece(board, piece, loc)

		current_piece += 1
	end

	return highest_rock(board)
end

def solution_part_2(input)
	return 2
end

describe "Day 17" do
	
	it "Part 1 should pass" do
		expect(solution_part_1(test_input)).to eq(part_1_expected)
		p solution_part_1(real_input)
	end

	it "Part 2 should pass", skip: true do
		expect(solution_part_2(test_input)).to eq(part_2_expected)
		p solution_part_2(real_input)
	end
end
