require 'aoc/helpers'

test_input = File.read('./test-input.txt')
real_input = get_input(2022, 20, File.read('/home/vscode/.adventofcode.session'))

part_1_expected = 3
part_2_expected = 1623178306

Entry = Struct.new(
	:index,
	:offset
)

def parse_input(input)
	lines(input).map.with_index{ |l, i| Entry.new(i, l.to_i) }
end

def swap(arr, a, b)
	arr[a], arr[b] = arr[b], arr[a]
end

def decrypt_file(input, iterations = 1)
	ans = input

	p ans.map(&:offset) if ans.length < 20
	iterations.times do
		input.count.times do |i|
			v = input.find{_1.index == i}
			index = ans.index(v)
			new_index = (index + v.offset) 

			next if index == new_index
			direction = (new_index - index) / (new_index - index).abs

			new_index += direction if new_index != new_index % ans.length
			new_index %= ans.length

			unless v.offset == 0
				ans.delete_at(index)
				# new_index -= 1 if v.offset.negative? && v.offset.abs >= index
				ans.insert(new_index, v)
			end
		end
		ans = ans.rotate until ans[0].offset == 0
		p ans.map(&:offset) if ans.length < 20
	end

	ans = ans.map(&:offset)
end

def solution_part_1(input)
	input = parse_input(input)
	ans = decrypt_file(input)
	ans = ans.rotate until ans[0] == 0

	zero_index = ans.index(0)
	[1000, 2000, 3000].map{ans[(_1 + zero_index) % ans.length]}.reduce(:+)
end

def solution_part_2(input)
	input = parse_input(input).map{_1.offset *= 811589153; _1}

	ans = decrypt_file(input, 10)
	ans = ans.rotate until ans[0] == 0

	zero_index = ans.index(0)
	[1000, 2000, 3000].map{ans[(_1 + zero_index) % ans.length]}#.reduce(:+)
end

describe "Day 20" do
	
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
