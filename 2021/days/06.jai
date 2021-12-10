#import "Basic";
#import "File";
#import "String";
#import "Hash_Table";

part1 :: (fishes : [] int) -> int {
	lanternfish : [..] int;
	defer free(*lanternfish);
	for fishes array_add(*lanternfish, it);
	
	
	for day: 1..80 {

		to_add := 0;
		for * lanternfish {
			if <<it == 0 {
				<<it = 7;
				to_add += 1;
			}
			<<it = <<it - 1;
		}

		for 1..to_add array_add(*lanternfish, 8);
	}

	return lanternfish.count;
}

part2 :: (fishes : [] int) -> int {
	lanternfish : [..] int;
	defer free(*lanternfish);
	for fishes array_add(*lanternfish, it);
	
	cache : [10] int;
	for * cache { <<it = -1; };

	n := 0;

	memoizer : Table(int, int);

	rec :: (x: int, mem: *Table(int, int)) -> int {
		if x <= 0 return 1;

		v, found := table_find(<<mem, x);
		if found return v;

		v = rec(x - 7, mem) + rec(x - 9, mem);
		table_set(mem, x, v);
		return v;
	}
	for lanternfish {
		if cache[it] > 0 {
			n += cache[it];
			continue;
		}

		days_left := 256 - it;
		cache[it] = rec(days_left, *memoizer);
		n += cache[it];
	}

	return n;
}

main :: () -> (int, int) {
	input, success := read_entire_file("Inputs/06.txt");
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