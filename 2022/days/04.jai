#scope_file
#import "Basic";
#import "File";
#import "Sort";
#import "String";

#scope_export
part1 :: (input: string) -> int {
	found: bool;
	line: string;
	rest := input;

	sum := 0;
	while true {
		found, line, rest = split_from_left(rest, #char "\n");
		if !found break;

		a: int;
		b: int;
		x: int;
		y: int;

		if !scan2(line, "%-%,%-%", *a, *b, *x, *y) continue;

		     if a <= x && y <= b sum += 1;
		else if x <= a && b <= y sum += 1;
	}

	return sum;
}

part2 :: (input: string) -> int {
	found: bool;
	line: string;
	rest := input;

	sum := 0;
	while true {
		found, line, rest = split_from_left(rest, #char "\n");
		if !found break;

		a: int;
		b: int;
		x: int;
		y: int;

		if !scan2(line, "%-%,%-%", *a, *b, *x, *y) continue;

		if !(b < x || y < a) sum += 1;
	}

	return sum;
}

main :: () -> (int, int) {
	input, success := read_entire_file("Inputs/04.txt");
	if !success {
		print("Error reading input\n");
		return (-1, -1);
	}

	return part1(input), part2(input);
}