#import "Basic";
#import "File";
#import "String";

Line :: struct {
	x1 : int;
	y1 : int;
	x2 : int;
	y2 : int;
}

part1 :: (lines : [] Line) -> int {
	w := 0;
	h := 0;

	for lines {
		w = max(w, it.x1);
		w = max(w, it.x2);
		h = max(h, it.y1);
		h = max(h, it.y2);
	}

	w += 1;
	h += 1;

	n_grid : [..] int;
	array_resize(*n_grid, w * h);
	for *n_grid { <<it = 0; }

	for lines if (it.x1 == it.x2) || (it.y1 == it.y2) {
		x1 := min(it.x1, it.x2);
		x2 := max(it.x1, it.x2);
		y1 := min(it.y1, it.y2);
		y2 := max(it.y1, it.y2);

		for x: x1..x2 for y: y1..y2 n_grid[x + y * w] += 1;
	}

	n := 0;
	for n_grid if it > 1 n += 1;

	// for y: 0..h-1 {
	// 	for x: 0..w-1 {
	// 		print("% ", n_grid[x + y * w]);
	// 	}
	// 	print("\n");
	// }

	return n;
}

sign :: (x: int) -> int {
	if x > 0 return +1;
	if x < 0 return -1;
	return 0;
}
abs :: (x: int) -> int { return ifx x > 0 x else -x; }

part2 :: (lines : [] Line) -> int {
	w := 0;
	h := 0;

	for lines {
		w = max(w, it.x1);
		w = max(w, it.x2);
		h = max(h, it.y1);
		h = max(h, it.y2);
	}

	w += 1;
	h += 1;

	n_grid : [..] int;
	array_resize(*n_grid, w * h);
	for *n_grid { <<it = 0; }

	for lines {
		t_max := abs(it.x2 - it.x1);
		t_max = max(t_max, abs(it.y2 - it.y1));
		
		for t: 0..t_max {
			x := it.x1 + t * sign(it.x2 - it.x1);
			y := it.y1 + t * sign(it.y2 - it.y1);

			n_grid[x + y * w] += 1;
		}
	}

	n := 0;
	for n_grid if it > 1 n += 1;

	// for y: 0..h-1 {
	// 	for x: 0..w-1 {
	// 		print("% ", n_grid[x + y * w]);
	// 	}
	// 	print("\n");
	// }

	return n;
}

main :: () -> (int, int) {
	input, success := read_entire_file("Inputs/05.txt");
	if !success {
		print("Error reading input\n");
		return -1, -1;
	}

	file_lines := split(input, "\n");
	lines : [..] Line;
	array_reserve(*lines, file_lines.count);
	defer free(*lines);

	for file_lines if it.data {
		t := split(it, "->");
		l : Line;
		l.x1 = to_integer(split(t[0], ",")[0]);
		l.y1 = to_integer(split(t[0], ",")[1]);
		l.x2 = to_integer(split(t[1], ",")[0]);
		l.y2 = to_integer(split(t[1], ",")[1]);

		array_add(*lines, l);
	}
	
	return part1(lines), part2(lines);
}