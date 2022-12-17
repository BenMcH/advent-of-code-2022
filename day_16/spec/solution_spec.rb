require 'aoc/helpers'

test_input = File.read('./test-input.txt')
real_input = get_input(2022, 16, File.read('/home/vscode/.adventofcode.session'))

part_1_expected = 1651
part_2_expected = 1707

Tunnel = Struct.new(
	:destination,
	:minutes
)

Valve = Struct.new(
	:identity,
	:flow,
	:tunnels,
	:open,
	:optimized_tunnels,
)

def distance_between(graph, a, b, visited = [], distance = 1)
	graph_point = graph[a]

	return distance if graph_point.tunnels.include?(b)

	visited << a

	dist = (graph_point.tunnels - visited).map do |guess|
		distance_between(graph, guess, b, visited.dup, distance + 1) || 1E9
	end

	return dist.min
end

def parse_input(input)
	board = {}
	lines(input).each do |line|
		identity, *tunnels = *line.scan(/[A-Z]{2}/)
		flow = line.scan(/\d+/).first.to_i

		board[identity] = Valve.new(
			identity,
			flow,
			tunnels,
			false,
			{}
		)
	end

	board
end

def optimize_graph(input)
	flow_tunnels = input.values.filter{|v| v.flow > 0}
	flow_tunnels << input['AA']

	flow_tunnels.each do |changing_valve|
		flow_tunnels.each do |other_valve|
			next if other_valve == changing_valve

			input[changing_valve.identity].optimized_tunnels[other_valve.identity] = distance_between(input, changing_valve.identity, other_valve.identity)
		end
	end
end

def maximize_walk(board, point = 'AA', minute_score = 0, minutes_left = 30, visited = [])
	valve = board[point]
	visited = visited.dup

	if valve.flow > 0 && !visited.include?(point)
		visited << point

		return minute_score + maximize_walk(board, point, minute_score+valve.flow, minutes_left - 1, visited)
	end

	get_distance = Proc.new{|v| valve.optimized_tunnels[v]}

	pointed = board.values.filter{|p| !visited.include?(p.identity) && p.flow > 0 && get_distance.call(p.identity) < minutes_left}

	if pointed.any?
		return pointed.map{|t|
			dist_to_t = valve.optimized_tunnels[t.identity]

			minute_score * dist_to_t + maximize_walk(board, t.identity, minute_score, minutes_left - dist_to_t, visited)
		}.max
	end

	return minute_score * minutes_left
end

def solution_part_1(input)
	input = parse_input(input)

	optimize_graph(input)

	maximize_walk(input)
end

def solution_part_2(input)
	return 2
end

describe "Day 16" do
	
	it "Part 1 should pass" do
		expect(solution_part_1(test_input)).to eq(part_1_expected)
		p "passed"
		p solution_part_1(real_input)
	end

	it "Part 2 should pass" do
		expect(solution_part_2(test_input)).to eq(part_2_expected)
		p solution_part_2(real_input)
	end
end
