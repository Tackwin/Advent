#import "Basic";
#import "File";
#import "String";


Move :: struct {
	dir : enum {
		Up;
		Forward;
		Down;
	};

	amount : int;
};

part1 :: (lines: [] Move) -> int {
	if lines.count == 0 return 0;

	x := 0;
	y := 0;

	for lines {
		if it.dir == {
			case .Forward; x += it.amount;
			case .Up;      y -= it.amount;
			case .Down;    y += it.amount;
		}
	}

	return x * y;
}

part2 :: (lines: [] Move) -> int {
	if lines.count == 0 return 0;

	x := 0;
	y := 0;

	aim := 0;

	for lines {
		if it.dir == {
			case .Forward; x += it.amount; y += aim * it.amount;
			case .Up;      aim -= it.amount;
			case .Down;    aim += it.amount;
		}
	}

	return x * y;
}

main :: () -> (int, int) {
	input, success := read_entire_file("Inputs/02.txt");
	if !success {
		print("Error reading input\n");
		return -1, -1;
	}

	lines := split(input, "\n");
	move_lines : [..] Move;
	defer { free(*move_lines); }

	for lines if it.data {
		first := find_index_from_left(it, #char " ");
		dir := slice(it, 0, first);

		move : Move;
		if dir == {
			case "forward"; move.dir = .Forward;
			case "up";      move.dir = .Up;
			case "down";    move.dir = .Down;
		}

		move.amount = parse_int(*slice(it, first + 1, it.count));
		array_add(*move_lines, move);
	}

	return part1(move_lines), part2(move_lines);
}