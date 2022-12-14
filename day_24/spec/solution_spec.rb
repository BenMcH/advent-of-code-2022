require 'aoc/helpers'

test_input = File.read('./test-input.txt')
real_input = get_input(2022, 24, File.read('/home/vscode/.adventofcode.session'))

part_1_expected = 1
part_2_expected = 2

def solution_part_1(input)
	return 1
end

def solution_part_2(input)
	return 2
end

describe "Day 24" do
	
	it "Part 1 should pass" do
		expect(solution_part_1(test_input)).to eq(part_1_expected)
		p solution_part_1(real_input)
	end

	it "Part 2 should pass" do
		expect(solution_part_2(test_input)).to eq(part_2_expected)
		p solution_part_2(real_input)
	end
end
