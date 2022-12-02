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

	play_score = 1 + MY_PLAYS.index(me)

	return play_score + DRAW if their_index == my_index
	return play_score + WIN if (their_index == 0 && my_index == 1) || (their_index == 1 && my_index == 2) || (their_index == 2 && my_index == 0)
	return play_score + LOSE
end

def score_games(input, replacement_map = nil)
	input.lines.map {|line|
		them, me = *line.split(" ")

		me = replacement_map[[them, me]] if replacement_map

		score_round(them, me)
	}.sum
end

describe "Day 2" do

	it "Part 1 should pass" do
		scores = score_games(test_input)
		expect(scores).to eq(15)

		scores = score_games(real_input)
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

	it "Part 2 should pass" do
		expect(score_games(test_input, PART_2_PLAY_MAP)).to eq(12)

		puts "Part 2 #{score_games(real_input, PART_2_PLAY_MAP)}"
	end
end
