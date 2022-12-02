test_input = File.read('./test-input.txt')
real_input = File.exists?('./input') ? File.read('./input') : ''

THEIR_PLAYS = [
	'A',
	'B',
	'C',
]
MY_PLAYS = [ 
	'X',
	'Y',
	'Z',
 ]

LOSE = 0
DRAW = 3
WIN = 6

def score_round(them, me)
	their_index = THEIR_PLAYS.index(them)
	my_index = MY_PLAYS.index(me)
	return DRAW if their_index == my_index
	return WIN if (their_index == 0 && my_index == 1) || (their_index == 1 && my_index == 2) || (their_index == 2 && my_index == 0)
	return LOSE
end

describe "Day 2" do

	def part_1(input)
		input.lines.map {|line|
		
			them, me = *line.split(" ")

			score = score_round(them, me)


			play_score = 1 + MY_PLAYS.index(me)

			score + play_score
		}.sum
	end

	it "Part 1 should pass" do
		scores = part_1(test_input)
		expect(scores).to eq(15)

		scores = part_1(real_input)
		puts "Part 1 #{scores}"
	end

	PART_2_PLAY_MAP = {
		['A', 'X'] => "Z",
		['B', 'X'] => "X",
		['C', 'X'] => "Y",
		['A', 'Y'] => "X",
		['B', 'Y'] => "Y",
		['C', 'Y'] => "Z",
		['A', 'Z'] => "Y",
		['B', 'Z'] => "Z",
		['C', 'Z'] => "X",
	}

	def part_2(input)
		input.lines.map {|line|
		
			them, me = *line.split(" ")

			me = PART_2_PLAY_MAP[[them, me]]

			score = score_round(them, me)


			play_score = 1 + MY_PLAYS.index(me)

			score + play_score
		}.sum
	end

	it "Part 2 should pass" do
		expect(part_2(test_input)).to eq(12)

		puts "Part 2 #{part_2(real_input)}"
	end
end
