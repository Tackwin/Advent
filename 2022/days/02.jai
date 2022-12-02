#scope_file
#import "Basic";
#import "File";
#import "Sort";
#import "String";

compute_score :: (a: int, b: int) -> int {
	score := 0;
	if b == 0 score = 1;
	if b == 1 score = 2;
	if b == 2 score = 3;

	if a == b score += 3;
	if a == 0 && b == 1 score += 6;
	if a == 1 && b == 2 score += 6;
	if a == 2 && b == 0 score += 6;

	return score;
}

#scope_export
part1 :: (input: string) -> int {

	sum_score := 0;
	found: bool;
	line: string;
	rest := input;

	while true {
		found, line, rest = split_from_left(rest, #char "\n");
		if !found break;
		if line.count != 3 break;

		a := line[0] - #char "A";
		b := line[2] - #char "X";

		sum_score += compute_score(a, b);
	}

	return sum_score;
}

part2 :: (input: string) -> int {
	sum_score := 0;
	found: bool;
	line: string;
	rest := input;

	while true {
		found, line, rest = split_from_left(rest, #char "\n");
		if !found break;
		if line.count != 3 break;

		a := line[0] - #char "A";
		b := 0;
		if line[2] == #char "X" b = (a + 2) % 3;
		if line[2] == #char "Y" b = (a + 0) % 3;
		if line[2] == #char "Z" b = (a + 1) % 3;

		sum_score += compute_score(a, b);
	}

	return sum_score;
}

main :: () -> (int, int) {
	input, success := read_entire_file("Inputs/02.txt");
	if !success {
		print("Error reading input\n");
		return (-1, -1);
	}

	return part1(input), part2(input);
}