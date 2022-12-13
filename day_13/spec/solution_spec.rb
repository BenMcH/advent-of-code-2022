require 'aoc/helpers'

test_input = File.read('./test-input.txt')
real_input = get_input(2022, 13, File.read("/home/vscode/.adventofcode.session"))

part_1_expected = 13
part_2_expected = 2

def compare_index(l_val, r_val)
	left_int = l_val.is_a? Integer
	right_int = r_val.is_a? Integer

	if left_int == right_int && left_int # 2 Integers
		return false if l_val > r_val
		return true if l_val < r_val
	elsif left_int ^ right_int # 1 integer
		if left_int
			l_val = [l_val]
		else
			r_val = [r_val]
		end

		return compare_index(l_val, r_val)
	else
		cycles = 0
		l_val.length.times do |i|
			return false if i == r_val.length
			return false if compare_index(l_val[i], r_val[i]) == false
			cycles+=1
		end
		
		if cycles <= r_val.length
			return true
		end
	end
end

def compare_packets(left, right)
	left.length.times do |i|
		return false if right.length == i
		l_val = left[i]
		r_val = right[i]

		res = compare_index(l_val, r_val)
		if res
			return true
		end

		if res == false
			return false
		end
	end

	return true	
end

def solution_part_1(input)
	pairs = input.split("\n\n").map{|group| lines(group).map{|v| eval(v)}}

	indicies = []
	pairs.each_with_index do |p, i|
		left, right = *p

		if compare_packets(left, right) == true
			indicies << i + 1
		end
	end
	p indicies

	indicies.sum
end

def solution_part_2(input)
	return 2
end

describe "Day 13" do
	
	it "returns true for the first set" do
		t = "[1,1,3,1,1]\n[1,1,5,1,1]"
		pairs = lines(t).map{|v| eval(v)}
		expect(compare_packets(pairs[0], pairs[1])).to eq(true)
	end

	it "true for second case", focus: true do
		t = "[[1],[2,3,4]]
[[1],4]"
		pairs = lines(t).map{|v| eval(v)}
		expect(compare_packets(pairs[0], pairs[1])).to eq(true)
	end

	it "false for third case" do
		t = "[9]
[[8,7,6]]"
		pairs = lines(t).map{|v| eval(v)}

		expect(compare_packets(pairs[0], pairs[1])).to eq(false)
	end

	it "true 4th" do
		t = "[[4,4],4,4]
[[4,4],4,4,4]"
		pairs = lines(t).map{|v| eval(v)}

		expect(compare_packets(pairs[0], pairs[1])).to eq(true)
	end

	it "false 5th" do
		t = "[7,7,7,7]
[7,7,7]"
		pairs = lines(t).map{|v| eval(v)}

		expect(compare_packets(pairs[0], pairs[1])).to eq(false)
	end

	it "true 6th" do
		t = "[]
[3]"
		pairs = lines(t).map{|v| eval(v)}

		expect(compare_packets(pairs[0], pairs[1])).to eq(true)
	end

	it "false 7th" do
		t = "[[[]]]
[[]]"
		pairs = lines(t).map{|v| eval(v)}

		expect(compare_packets(pairs[0], pairs[1])).to eq(false)
	end

	it "false 8th" do
		t = "[1,[2,[3,[4,[5,6,7]]]],8,9]
[1,[2,[3,[4,[5,6,0]]]],8,9]"
		pairs = lines(t).map{|v| eval(v)}

		expect(compare_packets(pairs[0], pairs[1])).to eq(false)
	end

	it "Part 1 should pass" do
		expect(solution_part_1(test_input)).to eq(part_1_expected)
		p solution_part_1(real_input)
	end

	# it "Part 2 should pass" do
	# 	expect(solution_part_2(test_input)).to eq(part_2_expected)
	# 	p solution_part_2(real_input)
	# end
end
