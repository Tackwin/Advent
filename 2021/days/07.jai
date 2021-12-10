#import "Basic";
#import "File";
#import "String";

abs :: (x: int) -> int { return ifx x > 0 x else -x; }

part1 :: (fishes : [] int) -> int {

	last := 1 << 61;
	curr := 1 << 61;

	n := 0;
	while curr <= last {
		last = curr;

		diff := 0;
		for f: fishes diff += abs(f - n);

		curr = diff;

		n += 1;
	}

	return last;
}

part2 :: (fishes : [] int) -> int {

	last := 1 << 61;
	curr := 1 << 61;

	n := 0;
	while curr <= last {
		last = curr;

		diff := 0;
		for f: fishes diff += abs(f - n) * (abs(f - n) + 1);

		curr = diff / 2;

		n += 1;
	}

	return last;
}

main :: () -> (int, int) {
	input, success := read_entire_file("Inputs/07.txt");
	if !success {
		print("Error reading input\n");
		return -1, -1;
	}

	ages := split(input, ",");
	ages_int : [..] int;
	array_reserve(*ages_int, ages.count);

	for ages if it.data {
		x, success, __ := to_integer(it);
		if !success continue;
		array_add(*ages_int, x);
	}
	
	return part1(ages_int), part2(ages_int);
}