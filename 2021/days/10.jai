#import "Basic";
#import "File";
#import "String";
#import "Sort";

lut1 : [256] int;
lut2 : [256] int;

part1 :: (lines : [] string) -> int {
	stack : [..] u8;

	score := 0;
	for line: lines if line.data {
		stack.count = 0;
		for 0..line.count-1 {
			c := line[it];
			
			if find_index_from_left("[{<(", c) >= 0 {
				array_add(*stack, c);
			}
			if find_index_from_left("]}>)", c) >= 0 {
				if stack.count == 0 continue;

				last := stack[stack.count - 1];
				stack.count -= 1;

				if last == {
					case #char "("; if c != #char ")" {
						score += lut1[c];
						break;
					}
					case #char "["; if c != #char "]" {
						score += lut1[c];
						break;
					}
					case #char "{"; if c != #char "}" {
						score += lut1[c];
						break;
					}
					case #char "<"; if c != #char ">" {
						score += lut1[c];
						break;
					}
				}
			}
		}
	}

	return score;
}

part2 :: (lines : [] string) -> int {
	stack : [..] u8;

	scores : [..] int;
	for line: lines if line.data {
		stack.count = 0;
		for 0..line.count-1 {
			c := line[it];
			
			if find_index_from_left("[{<(", c) >= 0 {
				array_add(*stack, c);
			}
			if find_index_from_left("]}>)", c) >= 0 {
				if stack.count == 0 continue;

				last := stack[stack.count - 1];
				stack.count -= 1;

				if last == {
					case #char "("; if c != #char ")" continue line;
					case #char "["; if c != #char "]" continue line;
					case #char "{"; if c != #char "}" continue line;
					case #char "<"; if c != #char ">" continue line;
				}
			}
		}

		score := 0;

		for < stack {
			score *= 5;
			score += lut2[it];
		}

		array_add(*scores, score);
	}

	quick_sort(scores, x => x);

	return scores[scores.count / 2];
}

main :: () -> (int, int) {
	for * lut1 { <<it = 0; };
	for * lut2 { <<it = 0; };

	lut1[#char ")"] = 3;
	lut1[#char "]"] = 57;
	lut1[#char "}"] = 1197;
	lut1[#char ">"] = 25137;

	lut2[#char "("] = 1;
	lut2[#char "["] = 2;
	lut2[#char "{"] = 3;
	lut2[#char "<"] = 4;

	input, success := read_entire_file("Inputs/10.txt");
	if !success {
		print("Error reading input\n");
		return -1, -1;
	}

	lines := split(input, "\n");
	return part1(lines), part2(lines);
}