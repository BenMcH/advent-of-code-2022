require 'aoc/helpers'

test_input = File.read('./test-input.txt')
real_input = get_input(2022, 22, File.read('/home/vscode/.adventofcode.session'))

part_1_expected = 6032
part_2_expected = 2
WALL = "#"
FREE_SPACE = "."

# [y, x]
UP = [-1, 0]
DOWN = [1, 0]
LEFT = [0, -1]
RIGHT = [0, 1]

DIRECTIONS = [
	RIGHT,
	DOWN,
	LEFT,
	UP
]

def parse_input(input)
	board, instructions = input.split("\n\n")

	instructions = instructions.scan /\d+|R|L/
	board_lines = lines(board)
	max_len = board_lines.map(&:length).max

	board = board_lines.map{
		arr = _1.chars
		diff = max_len - arr.length

		additional = [' '] * diff

		arr.concat(additional)
	}

	[board, instructions]
end

def solution_part_1(input)
	board, instructions = *parse_input(input)

	pos = [0, board[0].index(FREE_SPACE)]
	current_direction = 0

	File.write("board.json", board.to_s)
	instructions.each do |instruction|
		num = instruction.to_i
		direction = DIRECTIONS[current_direction % DIRECTIONS.length]
		if num > 0 # was a number
			num.times do
				if direction[0] == 0 #Moving left/right
					board_row = board[pos[0]]
					new_x = (direction[1] + pos[1]) % board_row.length
					new_pos = [pos[0], new_x]

					new_x = (new_x + direction[1]) % board_row.length until board_row[new_x] != ' '

					if board_row[new_x] == '.'
						pos = [pos[0], new_x]
					elsif board_row[new_x] == '#' # hit wall
						break
					else
						throw Exception.new("Why?!")
					end
				else # Moving up/down
					board_row = board.transpose[pos[1]]
					new_y = (direction[0] + pos[0]) % board_row.length
					new_pos = [new_y, pos[1]]

					new_y = (new_y + direction[0]) % board_row.length until board_row[new_y] != ' '

					if board_row[new_y] == '.'
						pos = [new_y, pos[1]]
					elsif board_row[new_y] == '#' # hit wall
						break
					else
						throw Exception.new("Why?!")
					end
				end
			end
		else
			if instruction == 'R'
				current_direction += 1
			elsif instruction == 'L'
				current_direction -= 1
			else
				throw Exception.new("Unknown command: #{instruction}")
			end
		end
	end

	p [pos[0]+1, pos[1]+1, current_direction%DIRECTIONS.length]
	1000 * (pos[0] + 1) + 4 * (pos[1] + 1) + (current_direction % DIRECTIONS.length)
end

def solution_part_2(input)
	return 2
end

describe "Day 22" do
	it "Part 1 should pass" do
		expect(solution_part_1(test_input)).to eq(part_1_expected)
		p "passed 1"
		p solution_part_1(real_input)
	end

	it "Part 2 should pass" do
		expect(solution_part_2(test_input)).to eq(part_2_expected)
		p solution_part_2(real_input)
	end
end
