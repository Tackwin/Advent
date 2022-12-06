#scope_file
#import "Basic";
#import "File";
#import "Sort";
#import "String";

#scope_export
part1 :: (input: string) -> int {
	for 4..input.count - 1 {
		a := input[it - 1];
		b := input[it - 2];
		c := input[it - 3];
		d := input[it - 4];
		if a == b continue;
		if a == c continue;
		if a == d continue;
		if b == c continue;
		if b == d continue;
		if c == d continue;

		return it;
	}

	return -1;
}

part2 :: (input: string) -> int {
	t: [256] bool;

	for it: 14..input.count - 1 {
		memset(t.data, 0, t.count);
		for jt: it-14..it-1 if t[input[jt]] continue it; else t[input[jt]] = true;
		return it;
	}

	return -1;
}

main :: () -> (int, int) {
	input, success :: #run read_entire_file("Inputs/06.txt");
	if !success {
		print("Error reading input\n");
		return -1, -1;
	}

	return part1(input), part2(input);
}