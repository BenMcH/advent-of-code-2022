require 'aoc/helpers'

test_input = File.read('./test-input.txt')
real_input = get_input(2022, 18, File.read('/home/vscode/.adventofcode.session'))

part_1_expected = 64
part_2_expected = 58

Cube = Struct.new(
	:x,
	:y,
	:z
) do 
	def to_arr
		[x, y, z]
	end
end

def parse_input(input)
	lines(input).map{|line| Cube.new(*get_numbers(line))}
end

def solution_part_1(input)
	cubes = parse_input(input)
	map = {}

	cubes.each do |cube|
		key = [cube.x, cube.y, cube.z]

		map[key] = true
	end

	count = 0

	cubes.each do |cube|
		BORDER_MATRICES.each do |direction|
			new_loc = cube.to_arr

			new_loc = new_loc.map.with_index do |v, i|
				v + direction[i]
			end

			count += 1 unless map[new_loc]
		end
	end

	return count
end

def solution_part_2(input)
	cubes = parse_input(input)
	map = {}

	max_x = cubes.map(&:x).max
	max_y = cubes.map(&:y).max
	max_z = cubes.map(&:z).max

	max = [max_x, max_y, max_z].max

	cubes.each do |cube|
		key = [cube.x, cube.y, cube.z]

		map[key] = true
	end

	count = 0

	cubes.each do |cube|
		BORDER_MATRICES.each do |direction|
			new_loc = cube.to_arr

			new_loc = new_loc.map.with_index do |v, i|
				v + direction[i]
			end

			unless map[new_loc]
				unless surrounded(map, new_loc, max)
					count += 1
				else
					fill(map, new_loc)
				end
			end
		end
	end

	return count
end

def fill(map, loc)
	map[loc] = true

	BORDER_MATRICES.each do |direction|
		new_loc = loc.map.with_index do |v, i|
			v + direction[i]
		end

		if map[new_loc].nil?
			fill(map, new_loc)
		end
	end
end

def flood_exterior(map, max)
	starting = [-1, -1, -1]

end

BORDER_MATRICES = [
	[1,0,0],
	[0,1,0],
	[0,0,1],
	[-1,0,0],
	[0,-1,0],
	[0,0,-1],
]

def surrounded(map, location, max, visited = [])
	BORDER_MATRICES.all? do |direction|
		new_loc = location.map.with_index do |v, i|
			v + direction[i]
		end

		if map[new_loc] || visited.include?(new_loc)
			true
		else
			if new_loc.any? {|v| v < 0 || v > max}
				false
			else
				visited << new_loc
				surrounded(map, new_loc, max, visited)
			end
		end
	end
end

describe "Day 18" do
	
	it "Part 1 should pass" do
		expect(solution_part_1(test_input)).to eq(part_1_expected)
		p solution_part_1(real_input)
	end

	it "Part 2 should pass" do
		expect(solution_part_2(test_input)).to eq(part_2_expected)
		p solution_part_2(real_input)
	end
end
