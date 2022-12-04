test_input = File.read('./test-input.txt')
real_input = File.read('./input')

def parse_elves(input)
	input.lines.flat_map do |str|
		str.split(',').map do |elf_sections|
			start, end_section = *elf_sections.split('-')

			(start.to_i)..(end_section.to_i)
		end
	end
end

def solution_part_1(input)
	elf_pairs = parse_elves(input)

	count = 0

	elf_pairs.each_slice(2) do |pair|
		e1, e2 = *pair

		count += 1 if e1.cover?(e2) || e2.cover?(e1)
	end

	return count
end

def solution_part_2(input)
	elf_pairs = parse_elves(input)

	count = 0

	elf_pairs.each_slice(2) do |pair|
		e1, e2 = *pair

		count += 1 if e1.cover?(e2.first) || e2.cover?(e1.first)
	end

	return count
end

describe "Day 4" do
	
	it "Part 1 should pass" do
		expect(solution_part_1(test_input)).to eq(2)
		p "part 1: #{solution_part_1(real_input)}"
	end

	it "Part 2 should pass" do
		expect(solution_part_2(test_input)).to eq(4)
		p "part 2: #{solution_part_2(real_input)}"
	end
end
