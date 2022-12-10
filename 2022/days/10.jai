#scope_file
#import "Basic";
#import "File";
#import "Sort";
#import "String";

Instruction :: struct {
	op: enum {
		Nop;
		Add;
	};
	arg: int;
}

#scope_export
part1 :: (input: string) -> string {
	found: bool;
	line: string;
	rest := input;

	cycle_cout := 0;
	records: [..] int;
	{
		n_lines := 0;
		for 0..input.count-1 if input[it] == #char "\n" n_lines += 1;
		array_reserve(*records, n_lines);
	}

	exec :: (X: int, inst: Instruction, records: *[..] int) -> int #expand {
		if inst.op == .Nop {
			cycle_cout += 1;
			if ((cycle_cout - 20) % 40 == 0) array_add(records, X * cycle_cout);
			return X;
		}
		if inst.op == .Add {
			cycle_cout += 1;
			if ((cycle_cout - 20) % 40 == 0) array_add(records, X * cycle_cout);
			cycle_cout += 1;
			if ((cycle_cout - 20) % 40 == 0) array_add(records, X * cycle_cout);
			return X + inst.arg;
		}
	}

	X := 1;
	while true {
		found, line, rest = split_from_left(rest, #char "\n");
		if !found break;

		if scan2(line, "noop") X = exec(X, .{op=.Nop, arg=0}, *records);
		inst: Instruction;
		inst.op = .Add;
		if scan2(line, "addx %", *inst.arg) X = exec(X, inst, *records);
	}

	n := 0;
	for records n += it;
	return tprint("%", n);
}

part2 :: (input: string) -> string {
	found: bool;
	line: string;
	rest := input;

	cycle_count := 0;
	records: [..] int;
	{
		n_lines := 0;
		for 0..input.count-1 if input[it] == #char "\n" n_lines += 1;
		array_reserve(*records, n_lines);
	}

	crt_buffer: [40*6] u8;
	for * crt_buffer { <<it = #char "."; }
	crt: string;
	crt.data = crt_buffer.data;
	crt.count = crt_buffer.count;

	exec :: (X: int, inst: Instruction, records: *[..] int) -> int #expand {
		if inst.op == .Nop {
			cycle_count += 1;
			if (-2 < ((cycle_count - 1) % 40) - X && ((cycle_count - 1) % 40) - X < 2)
				crt[cycle_count - 1] = #char "#";
			return X;
		}
		if inst.op == .Add {
			cycle_count += 1;
			if (-2 < ((cycle_count - 1) % 40) - X && ((cycle_count - 1) % 40) - X < 2)
				crt[cycle_count - 1] = #char "#";
			cycle_count += 1;
			if (-2 < ((cycle_count - 1) % 40) - X && ((cycle_count - 1) % 40) - X < 2)
				crt[cycle_count - 1] = #char "#";
			return X + inst.arg;
		}
	}

	X := 1;
	while true {
		found, line, rest = split_from_left(rest, #char "\n");
		if !found break;

		if scan2(line, "noop") X = exec(X, .{op=.Nop, arg=0}, *records);
		inst: Instruction;
		inst.op = .Add;
		if scan2(line, "addx %", *inst.arg) X = exec(X, inst, *records);
	}

	str: string;
	for y: 0..5 {
		line: string;
		line.data = crt.data + y * 40;
		line.count = 40;
		str = tprint("%\n         %", str, line);
	}

	return str;
}

main :: () -> (string, string) {
	input, success :: #run read_entire_file("Inputs/10.txt");
	if !success {
		print("Error reading input\n");
		return ("Error reading input\n", "Error reading input\n");
	}

	return part1(input), part2(input);
}