require 'aoc/helpers'

test_input = File.read('./test-input.txt')
real_input = get_input(2022, 14, File.read('/home/vscode/.adventofcode.session'))

part_1_expected = 24
part_2_expected = 2

def parse_input(input)
	board = {}

	lines(input).each{ |l|
		p l
		last_coords = nil
		l.split(" -> ").each do |coord|
			x, y = *coord.split(",").map(&:to_i)

			unless last_coords
				last_coords = [x, y]
				board[[x,y]] = '#'
			else
				min, max = *[last_coords[0], x].minmax
				if last_coords[0] == x
					min, max = *[last_coords[1], y].minmax
				end

				(min..max).each do |x|
					board[[x, y]] = '#'
				end
			end
		end
	}

	board
end

def get_lowest_point(board)
	board.keys.map(&:last).max
end

def simulate_sand(board, lowest_point, sand_loc = [500, 0])
	if sand_loc[1]+1 > lowest_point
		return nil
	end
	p sand_loc

	down = sand_loc.dup
	down[1] += 1

	unless board[down]
		return simulate_sand(board, lowest_point, down)
	end

	left = down.dup
	left[0] -= 1
	unless board[left]
		return simulate_sand(board, lowest_point, left)
	end

	right = down.dup
	right[0] += 1
	unless board[right]
		return simulate_sand(board, lowest_point, right)
	end


	sand_loc
end

def add_sand_granual(board)
	last_coords = [500, 0]
end

def solution_part_1(input)
	board = parse_input(input)
	lowest_point = get_lowest_point(board)

	count = 0
	successful = true
	while successful
		count += 1
		next_coord = simulate_sand(board, lowest_point)

		successful = !next_coord.nil?

		board[next_coord] = '.' if successful
	end

	return count
end

def solution_part_2(input)
	return 2
end

describe "Day 14" do
	
	it "Part 1 should pass" do
		expect(solution_part_1(test_input)).to eq(part_1_expected)
		# p solution_part_1(real_input)
	end

	it "Part 2 should pass" do
		expect(solution_part_2(test_input)).to eq(part_2_expected)
		p solution_part_2(real_input)
	end
end
