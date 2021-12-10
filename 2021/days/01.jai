#import "Basic";
#import "File";
#import "String";

part1 :: (lines: [] int) -> int {
	if lines.count == 0 return 0;

	n := 0;

	last := lines[0];
	for i: 1..lines.count-1 {
		if last < lines[i] n += 1;
		last = lines[i];
	}

	return n;
}

part2 :: (lines: [] int) -> int {
	if lines.count <= 3 return 0;

	n := 0;

	last := lines[0] + lines[1] + lines[2];
	curr := lines[1] + lines[2];

	for 3..lines.count - 1 {
		curr += lines[it];
		if last < curr n += 1;

		curr -= lines[it - 2];
		last += lines[it];
		last -= lines[it - 3];
	}

	return n;
}

main :: () -> (int, int) {
	input, success := read_entire_file("Inputs/01.txt");
	if !success {
		print("Error reading input\n");
		return (-1, -1);
	}

	lines := split(input, "\n");
	int_lines : [..] int;

	for lines array_add(*int_lines, parse_int(*it));

	return part1(int_lines), part2(int_lines);
}