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

		in1: [256] bool;
		in2: [256] bool;
		for * in1 { <<it = false; }
		for * in2 { <<it = false; }

		first  := slice(line, 0, line.count / 2);
		second := slice(line, line.count / 2, line.count / 2);

		for 0..first.count-1 in1[first[it]] = true;
		for 0..second.count-1 in2[second[it]] = true;

		for 0..255 if in1[it] && in2[it] {
			if #char "a" <= it && it <= #char "z" sum += 1 + it - #char "a";
			if #char "A" <= it && it <= #char "Z" sum += 27 + it - #char "A";
		}
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
		first := line;
		if !found break;
		found, line, rest = split_from_left(rest, #char "\n");
		second := line;
		if !found break;
		found, line, rest = split_from_left(rest, #char "\n");
		third := line;
		if !found break;

		in1: [256] bool;
		in2: [256] bool;
		in3: [256] bool;
		for * in1 { <<it = false; }
		for * in2 { <<it = false; }
		for * in3 { <<it = false; }

		for 0..first.count-1  in1[first[it]] = true;
		for 0..second.count-1 in2[second[it]] = true;
		for 0..third.count-1  in3[third[it]] = true;

		for 0..255 if in1[it] && in2[it] && in3[it] {
			if #char "a" <= it && it <= #char "z" sum += 1 + it - #char "a";
			if #char "A" <= it && it <= #char "Z" sum += 27 + it - #char "A";
		}
	}

	return sum;
}

main :: () -> (int, int) {
	input, success :: #run read_entire_file("Inputs/03.txt");
	if !success {
		print("Error reading input\n");
		return (-1, -1);
	}

	return part1(input), part2(input);
}