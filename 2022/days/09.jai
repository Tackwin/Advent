#scope_file
#import "Basic";
#import "File";
#import "Sort";
#import "String";
abs :: inline (x: int) -> int { return ifx x < 0 then -x else max(x, 1); }

#scope_export
part1 :: (input: string) -> int {
	found: bool;
	line: string;
	rest := input;

	n_lines := 0;
	for 0..input.count-1 if input[it] == #char "\n" n_lines += 1;

	V2 :: struct { x: int; y: int; }
	moves := NewArray(n_lines, V2, false);
	moves.count = 0;

	while true {
		found, line, rest = split_from_left(rest, #char "\n");
		if !found break;
		v: V2;
		     if scan2(line, "R %", *v.x) v.x;
		else if scan2(line, "L %", *v.x) v.x *= -1;
		else if scan2(line, "U %", *v.y) v.y;
		else if scan2(line, "D %", *v.y) v.y *= -1;
		moves.count += 1;
		moves[moves.count - 1] = v;
	}

	min_x := 0;
	min_y := 0;
	max_x := 0;
	max_y := 0;

	H: V2 = .{0, 0};
	for moves {
		H.x += it.x;
		H.y += it.y;
		min_x = min(min_x, H.x);
		min_y = min(min_y, H.y);
		max_x = max(max_x, H.x);
		max_y = max(max_y, H.y);
	}

	w := max_x - min_x + 1;
	h := max_y - min_y + 1;
	grid := NewArray(w * h, bool);

	H.x = -min_x;
	H.y = -min_y;
	T := H;

	make_move :: (grid: [] bool, w: int, h: int, H: *V2, T: *V2, it: V2) {
		H.x += it.x;
		H.y += it.y;

		dt: V2;
		dt.x = H.x - T.x;
		dt.y = H.y - T.y;
		if abs(dt.x) > 1 || abs(dt.y) > 1 {
			T.x += dt.x / abs(dt.x);
			T.y += dt.y / abs(dt.y);
		}
		grid[T.x + T.y * w] = true;
	}

	for moves {
		for 1..it.x make_move(grid, w, h, *H, *T, .{1, 0});
		for it.x..-1 make_move(grid, w, h, *H, *T, .{-1, 0});
		for 1..it.y make_move(grid, w, h, *H, *T, .{0, 1});
		for it.y..-1 make_move(grid, w, h, *H, *T, .{0, -1});
	}

	n := 0;
	for 0..w*h-1 if grid[it] n += 1;

	return n;
}

part2 :: (input: string) -> int {
	found: bool;
	line: string;
	rest := input;

	n_lines := 0;
	for 0..input.count-1 if input[it] == #char "\n" n_lines += 1;

	V2 :: struct { x: int; y: int; }
	moves := NewArray(n_lines, V2, false);
	moves.count = 0;

	while true {
		found, line, rest = split_from_left(rest, #char "\n");
		if !found break;
		v: V2;
		     if scan2(line, "R %", *v.x) v.x;
		else if scan2(line, "L %", *v.x) v.x *= -1;
		else if scan2(line, "U %", *v.y) v.y;
		else if scan2(line, "D %", *v.y) v.y *= -1;
		moves.count += 1;
		moves[moves.count - 1] = v;
	}

	min_x := 0;
	min_y := 0;
	max_x := 0;
	max_y := 0;

	H: V2 = .{0, 0};
	for moves {
		H.x += it.x;
		H.y += it.y;
		min_x = min(min_x, H.x);
		min_y = min(min_y, H.y);
		max_x = max(max_x, H.x);
		max_y = max(max_y, H.y);
	}

	w := max_x - min_x + 1;
	h := max_y - min_y + 1;
	grid := NewArray(w * h, bool);

	rope: [10] V2;
	for * rope {
		it.x = -min_x;
		it.y = -min_y;
	}

	make_move :: (grid: [] bool, w: int, h: int, it: V2, rope: [] V2) {
		rope[0].x += it.x;
		rope[0].y += it.y;

		for 1..rope.count-1 {
			H := rope[it - 1];
			T := *rope[it];
			
			dt: V2;
			dt.x = H.x - T.x;
			dt.y = H.y - T.y;
			if abs(dt.x) > 1 || abs(dt.y) > 1 {
				T.x += dt.x / abs(dt.x);
				T.y += dt.y / abs(dt.y);
			}
		}

		grid[rope[rope.count - 1].x + rope[rope.count - 1].y * w] = true;
	}

	for m: moves {
		for 1..m.x make_move(grid, w, h, .{1, 0}, rope);
		for m.x..-1 make_move(grid, w, h, .{-1, 0}, rope);
		for 1..m.y make_move(grid, w, h, .{0, 1}, rope);
		for m.y..-1 make_move(grid, w, h, .{0, -1}, rope);
	}

	n := 0;
	for 0..w*h-1 if grid[it] n += 1;

	return n;
}

main :: () -> (int, int) {
	input, success :: #run read_entire_file("Inputs/09.txt");
	if !success {
		print("Error reading input\n");
		return (-1, -1);
	}

	return part1(input), part2(input);
}