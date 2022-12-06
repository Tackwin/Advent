#scope_file
#import "Basic";
#import "File";
#import "Sort";
#import "String";

#scope_export
part1 :: (input: string) -> string {
	found: bool;
	line: string;
	rest := input;
	schema: string;

	found, schema, rest = split_from_left(rest, "\n\n");
	if !found return "";

	N_Stacks :: 9;
	stacks: [N_Stacks][..] u8;
	for * stacks array_reserve(it, 10);

	while true {
		found, line, schema = split_from_left(schema, #char "\n");
		if !found break;

		for 0..stacks.count-1 {
			c := line[it * 4 + 1];
			if !(#char "A" <= c && c <= #char "Z") continue;

			array_insert_at(*stacks[it], c, 0);
		}
	}

	while true {
		found, line, rest = split_from_left(rest, #char "\n");
		if !found break;

		move: int;
		from: int;
		to: int;
		if !scan2(line, "move % from % to %", *move, *from, *to) continue;
		from -= 1;
		to -= 1;


		for 0..move-1 {
			array_add(*stacks[to], stacks[from][stacks[from].count - 1]);
			stacks[from].count -= 1;
		}
	}

	top: [N_Stacks] u8;
	for * top {
		<<it = stacks[it_index][stacks[it_index].count - 1];
	}
	s: string;
	s.data = top.data;
	s.count = top.count;

	return tprint("%", s);
}

part2 :: (input: string) -> string {
	found: bool;
	line: string;
	rest := input;
	schema: string;

	found, schema, rest = split_from_left(rest, "\n\n");
	if !found return "";

	N_Stacks :: 9;
	stacks: [N_Stacks][..] u8;
	for * stacks array_reserve(it, 10);

	while true {
		found, line, schema = split_from_left(schema, #char "\n");
		if !found break;

		for 0..stacks.count-1 {
			c := line[it * 4 + 1];
			if !(#char "A" <= c && c <= #char "Z") continue;

			array_insert_at(*stacks[it], c, 0);
		}
	}

	while true {
		found, line, rest = split_from_left(rest, #char "\n");
		if !found break;

		move: int;
		from: int;
		to: int;
		if !scan2(line, "move % from % to %", *move, *from, *to) continue;
		from -= 1;
		to -= 1;


		for 0..move-1 {
			array_add(*stacks[to], stacks[from][stacks[from].count - move + it]);
		}
		stacks[from].count -= move;
	}

	top: [N_Stacks] u8;
	for * top {
		<<it = stacks[it_index][stacks[it_index].count - 1];
	}
	s: string;
	s.data = top.data;
	s.count = top.count;

	return tprint("%", s);
}

main :: () -> (string, string) {
	input, success :: #run read_entire_file("Inputs/05.txt");
	if !success {
		print("Error reading input\n");
		return "Error reading input", "Error reading input";
	}

	return part1(input), part2(input);
}