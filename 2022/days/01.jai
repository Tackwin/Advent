#scope_file
#import "Basic";
#import "File";
#import "Sort";
#import "String";

#scope_export
part1 :: (input: string) -> int {
	found: bool;
	left: string;
	rest := input;

	sum_cal := 0;
	max_cal := 0;
	while true {
		found, left, rest = split_from_left(rest, #char "\n");
		if !found break;

		if left.count == 0 {
			max_cal = max(max_cal, sum_cal);
			sum_cal = 0;
			continue;
		}

		this := 0;
		if !scan2(left, "%", *this) continue;
		sum_cal += this;
	}
	max_cal = max(max_cal, sum_cal);

	return max_cal;
}

part2 :: (input: string) -> int {
	found: bool;
	left: string;
	rest := input;

	sum_cal := 0;
	max_cal := 0;

	carries: [..] int;
	while true {
		found, left, rest = split_from_left(rest, #char "\n");
		if !found break;

		if left.count == 0 {
			array_add(*carries, sum_cal);
			sum_cal = 0;
			continue;
		}

		this := 0;
		if !scan2(left, "%", *this) continue;
		sum_cal += this;
	}
	array_add(*carries, sum_cal);

	quick_sort(carries, x => x);

	sum_cal = 0;
	if carries.count > 1 sum_cal += carries[carries.count - 1];
	if carries.count > 2 sum_cal += carries[carries.count - 2];
	if carries.count > 3 sum_cal += carries[carries.count - 3];

	return sum_cal;
}

main :: () -> (int, int) {
	input, success :: #run read_entire_file("Inputs/01.txt");
	if !success {
		print("Error reading input\n");
		return (-1, -1);
	}

	return part1(input), part2(input);
}