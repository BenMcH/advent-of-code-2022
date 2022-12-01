test_input = File.read('./test-input.txt').to_s
real_input = File.read('./input')

def calculate_elf_carry_weights(input)
	return input.split("\n\n").map{|elf| elf.split("\n").map(&:to_i).sum}
end

def solution_part_1(input)
	return calculate_elf_carry_weights(input).max
end

def solution_part_2(input)
	return calculate_elf_carry_weights(input).sort[-3..].sum
end

describe "Day 1" do
	
	it "Part 1 should pass" do
		expect(solution_part_1(test_input)).to eq(24000)
		p "Part 1 solution #{solution_part_1(real_input)}"
	end

	it "Part 2 should pass" do
		expect(solution_part_2(test_input)).to eq(45000)
		p "Part 2 solution #{solution_part_2(real_input)}"
	end
end
