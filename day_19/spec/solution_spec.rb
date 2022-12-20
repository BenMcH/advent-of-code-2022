require 'aoc/helpers'

test_input = File.read('./test-input.txt')
real_input = get_input(2022, 19, File.read('/home/vscode/.adventofcode.session'))

part_1_expected = 33
part_2_expected = 2

Blueprint = Struct.new(
	:id,
	:ore_robot_cost,
	:clay_robot_cost,
	:obsidian_robot_cost_ore,
	:obsidian_robot_cost_clay,
	:geode_robot_cost_ore,
	:geode_robot_cost_obsidian
)

State = Struct.new(
	:blueprint,
	:minutes_left,
	:ore_robots,
	:clay_robots,
	:obsidian_robots,
	:geode_robots,
	:ore,
	:clay,
	:obsidian,
	:geodes,
	:max_ore,
	:max_clay,
	:max_obsidian
) do
	def initialize(*)
		super
		self.ore_robots ||= 1
		self.clay_robots ||= 0
		self.obsidian_robots ||= 0
		self.geode_robots ||= 0
		self.ore ||= 0
		self.clay ||= 0
		self.obsidian ||= 0
		self.geodes ||= 0
		self.max_ore = [self.blueprint.geode_robot_cost_ore, self.blueprint.ore_robot_cost, self.blueprint.clay_robot_cost].max
		self.max_clay = self.blueprint.obsidian_robot_cost_clay
		self.max_obsidian = self.blueprint.geode_robot_cost_obsidian
	end

	def to_s
		"Time: #{self.minutes_left} Ore Robots: #{ore_robots} Clay Robots: #{clay_robots} Obsidian Robots: #{obsidian_robots} Geode Robots: #{self.geode_robots} Ore: #{self.ore} Clay: #{self.clay} Obsidian: #{self.obsidian} Geode: #{self.geodes}"
	end

	def can_make_geode_before_time_runs_out
		ore_cost = self.blueprint.geode_robot_cost_ore
		obsidian_cost = self.blueprint.geode_robot_cost_obsidian

		((ore_cost - self.ore) / self.ore_robots).ceil < self.minutes_left &&
		((ore_cost - self.ore) / self.ore_robots).ceil < self.minutes_left
	end

	def skip_minutes(n)
		if n >= self.minutes_left
			self.minutes_left = 0
			n = minutes_left
		else
			self.minutes_left -= n
		end

		self.ore += n * self.ore_robots
		self.clay += n * self.clay_robots
		self.obsidian += n * self.obsidian_robots
		self.geodes += n * self.geode_robots
	end

	def next_states
		states = []
		dup_state = self.dup

		return [self] if self.minutes_left == 0

		dup_state.minutes_left -= 1

		if self.ore >= self.blueprint.geode_robot_cost_ore && self.obsidian >= self.blueprint.geode_robot_cost_obsidian
			state = self.dup

				state.geode_robots += 1
				state.ore -= self.blueprint.geode_robot_cost_ore
				state.obsidian -= self.blueprint.geode_robot_cost_obsidian

				states << state
		end

		needs_more_obsidian = self.max_obsidian > self.obsidian_robots
			if needs_more_obsidian && self.ore >= self.blueprint.obsidian_robot_cost_ore && self.clay >= self.blueprint.obsidian_robot_cost_clay
				state = dup_state.dup

				state.obsidian_robots += 1
				state.ore -= self.blueprint.obsidian_robot_cost_ore
				state.clay -= self.blueprint.obsidian_robot_cost_clay

				states << state
			end

			needs_more_clay = self.max_clay > self.clay_robots
			if self.ore >= self.blueprint.clay_robot_cost && needs_more_clay
				state = dup_state.dup

				state.clay_robots += 1
				state.ore -= self.blueprint.clay_robot_cost

				states << state
			end

			needs_more_ore =  self.max_ore > self.ore_robots
			if self.ore >= self.blueprint.ore_robot_cost && needs_more_ore
				state = dup_state.dup

				state.ore_robots += 1
				state.ore -= self.blueprint.ore_robot_cost

				states << state
			end

			states << dup_state


		states.each do |state|
			state.ore += self.ore_robots
			state.clay += self.clay_robots
			state.obsidian += self.obsidian_robots
			state.geodes += self.geode_robots
		end

		states
	end
end

def parse_input(input)
	lines(input).map{|l| Blueprint.new(*get_numbers(l))}
end

def solution_part_1(input)
	blueprints = parse_input(input)
	states = blueprints.map{|bp| State.new(bp, 24)}


	max = 0
	total_quality = 0
	states.each.with_index do |state, i|
		p "Blueprint: #{state.blueprint.id}"
		round = 0
		inner_states = [state]
		lstates = []

		until round == 24
			lstates = inner_states

			inner_states = inner_states.flat_map(&:next_states)
			local_max = inner_states.map(&:geodes).max

			inner_states = inner_states.filter{|g| g.geodes == local_max}
			p "#{state.blueprint.id} #{round} #{inner_states.length} #{local_max}"
			round += 1
		end

		new_quality = inner_states.map{|a| a.blueprint.id * a.geodes}.max

		total_quality += new_quality
	end

	total_quality
end

def solution_part_2(input)
	return 2
end

describe "Day 19" do
	
	it "Part 1 should pass" do
		expect(solution_part_1(test_input)).to eq(part_1_expected)
		# p solution_part_1(real_input)
	end

	it "Part 2 should pass", skip: true do
		expect(solution_part_2(test_input)).to eq(part_2_expected)
		p solution_part_2(real_input)
	end
end
