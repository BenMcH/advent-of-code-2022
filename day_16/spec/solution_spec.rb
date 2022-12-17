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

ValveOpener = Struct.new(
	:minutes_left,
	:current_point,
	:minute_score
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

def maximize_walk(board, valve_opener, visited = [])
	valve = board[valve_opener.current_point]
	visited = visited.dup

	if valve.flow > 0 && !visited.include?(valve_opener.current_point)
		visited << valve_opener.current_point

		valve_opener = valve_opener.dup
		valve_opener.minutes_left -= 1
		old_score = valve_opener.minute_score
		valve_opener.minute_score += valve.flow

		return old_score + maximize_walk(board, valve_opener, visited)
	end

	get_distance = Proc.new{|v| valve.optimized_tunnels[v]}

	pointed = board.values.filter{|p| !visited.include?(p.identity) && p.flow > 0 && get_distance.call(p.identity) < valve_opener.minutes_left}

	distances = pointed.map{|p| get_distance.call(p.identity)}

	if pointed.any?
		return pointed.map{|t|
			dist_to_t = valve.optimized_tunnels[t.identity]

			vo = valve_opener.dup
			vo.current_point = t.identity
			vo.minutes_left -= dist_to_t
			old_score = valve_opener.minute_score

			old_score * dist_to_t + maximize_walk(board, vo, visited)
		}.max
	end

	if valve_opener.minutes_left > 0
		valve_opener = valve_opener.dup
		valve_opener.minutes_left -= 1

		return valve_opener.minute_score + maximize_walk(board, valve_opener, visited)
	else
		return 0
	end
end

def solution_part_1(input)
	input = parse_input(input)

	optimize_graph(input)

	opener = ValveOpener.new(30, 'AA', 0)

	maximize_walk(input, opener)
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

	it "Part 2 should pass", skip: true do
		expect(solution_part_2(test_input)).to eq(part_2_expected)
		p solution_part_2(real_input)
	end
end
