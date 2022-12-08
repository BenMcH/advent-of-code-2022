test_input = File.read('./test-input.txt')
real_input = File.read('./input')

def solution_part_1(input)
	grid = input.lines.map{|l| l.strip.chars.map(&:to_i)}

	count = 0

	grid.each.with_index do |arr, i|
		if i == 0 || i == grid.length - 1
			count += arr.length
			next
		end
		arr.each.with_index do |elem, j|
			visible = false

			visible ||= j == 0 || j == arr.length - 1 # On Edge
			visible ||= (0...i).all? { |new_i| grid[new_i][j] < elem } # Visible on the left
			visible ||= ((i+1)...grid.length).all? { |new_i| grid[new_i][j] < elem } # Visible on the right
			visible ||= (0...j).all? { |new_j| grid[i][new_j] < elem } # Visible on top
			visible ||= ((j+1)...arr.length).all? { |new_j| grid[i][new_j] < elem }

			if visible
				count += 1
			end
		end
	end

	return count
end

def solution_part_2(input)
	grid = input.lines.map{|l| l.strip.chars.map(&:to_i)}

	highest_scenic_score = 0

	grid.each.with_index do |arr, i|
		next if i == 0 || i == grid.length - 1 # On edge, at least 1 value is 0

		arr.each.with_index do |elem, j|
			next if j == 0 || j == arr.length # On edge, at least 1 value is 0

			scores = []
			score = 0
			
			for new_i in (i-1).downto(0)
				score += 1
				break if grid[new_i][j] >= grid[i][j]
			end

			scores << score
			score = 0
			
			for new_i in (i+1)...grid.length
				score += 1
				break if grid[new_i][j] >= grid[i][j]
			end

			scores << score
			score = 0
			
			for new_j in (j-1).downto(0)
				score += 1
				break if grid[i][new_j] > grid[i][j]
			end

			scores << score
			score = 0
			
			for new_j in (j+1)...arr.length
				score += 1
				break if grid[i][new_j] >= grid[i][j]
			end

			scores << score
			score = scores.reduce(1) {|product, value| product * value}

			highest_scenic_score = score if score > highest_scenic_score
		end

		highest_scenic_score
	end

	return highest_scenic_score
end

describe "Day 8" do
	
	it "Part 1 should pass" do
		expect(solution_part_1(test_input)).to eq(21)

		p solution_part_1(real_input)
	end

	it "Part 2 should pass" do
		expect(solution_part_2(test_input)).to eq(8)

		p solution_part_2(real_input)
	end
end
