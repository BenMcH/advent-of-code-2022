require 'aoc/helpers'

test_input = File.read('./test-input.txt')
real_input = Aoc::Helpers.get_input(2022, 12, File.read("/home/vscode/.adventofcode.session"))

part_1_expected = 31
part_2_expected = 2

def is_upper(letter)
	letter == letter.upcase
end

def parse_board(input)
	elevation_map = ('a'..'z').to_a
	input.split("\n").map{|row| row.split("").map{|letter| is_upper(letter) ? letter : elevation_map.index(letter)}}
end

def walk(map, location, destination, visited = [])
	visited_arr = visited.dup << location

	row, col = *location

	if location == destination
		return visited_arr.length
	end

	neighbors = []

	neighbors << [row-1, col] if row > 0
	neighbors << [row+1, col] if row < map.length - 1
	neighbors << [row, col - 1] if col > 0
	neighbors << [row, col + 1] if col < map[0].length - 1

	current_value = map[location[0]][location[1]]
	neighbors = neighbors.filter {|v| map[v[0]][v[1]] -1  <= current_value && !visited_arr.include?(v)}

	if neighbors.length == 0
		return -1
	end

	return neighbors.map{|n| walk(map, n, destination, visited_arr)}.min
end

def solution_part_1(input)
	input = parse_board(input)

	starting_location = nil
	ending_location = nil
	input.each_with_index do |row, i|
		row.each_with_index do |col, j|
			if col == 'S'
				input[i][j] = 0
				starting_location = [i,j]
			elsif col == 'E'
				input[i][j] = 25
				ending_location == [i,j]
			end
		end
	end

	length = walk(input, starting_location, ending_location)

	return length
end

def solution_part_2(input)
	return 2
end

describe "Day 12" do
	
	it "Part 1 should pass" do
		expect(solution_part_1(test_input)).to eq(part_1_expected)
		p solution_part_1(real_input)
	end

	it "Part 2 should pass" do
		expect(solution_part_2(test_input)).to eq(part_2_expected)
		p solution_part_2(real_input)
	end
end
