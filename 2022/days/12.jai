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

	terrain := NewArray(input.count, int);
	w := 0;
	h := 0;

	start := 0;
	end := 0;

	while true {
		found, line, rest = split_from_left(rest, #char "\n");
		if !found break;
		if line.count == 0 continue;

		h += 1;
		w = line.count;

		for 0..line.count - 1 {
			c := line[it];
			
			if c == #char "S" {
				start = it + (h - 1) * w;
				terrain[it + (h - 1) * w] = 0;
			}
			else if c == #char "E" {
				end = it + (h - 1) * w;
				terrain[it + (h - 1) * w] = #char "z" - #char "a";
			}
			else terrain[it + (h - 1) * w] = c - #char "a";
		}
	}

	visited := NewArray(w * h, bool);

	open: [..] int;
	array_add(*open, start);
	open.count = 1;
	cursor := 0;

	prev := NewArray(w * h, int);
	for * prev { <<it = -1; }

	// BFS to find shortest path
	while cursor < open.count {
		x := open[cursor];
		cursor += 1;

		if visited[x] continue;
		visited[x] = true;

		if x == end break;

		// Check all 4 directions
		for 0..3 {
			y := x;
			a := x % w;
			b := x / w;

			if it == 0 a -= 1;
			if it == 1 a += 1;
			if it == 2 b -= 1;
			if it == 3 b += 1;

			if a < 0 || a >= w continue;
			if b < 0 || b >= h continue;
			y = a + b * w;

			if visited[y] continue;
			if terrain[x] + 1 < terrain[y] continue;

			array_add(*open, y);
			prev[y] = x;
		}
	}

	// Reconstruct path
	path := NewArray(w * h, int);
	path.count = 0;
	x := end;
	while x != -1 {
		path.count += 1;
		path[path.count - 1] = x;
		x = prev[x];
	}

	return path.count - 1;
}

part2 :: (input: string) -> int {
	found: bool;
	line: string;
	rest := input;

	terrain := NewArray(input.count, int);
	w := 0;
	h := 0;

	start := 0;
	end := 0;

	while true {
		found, line, rest = split_from_left(rest, #char "\n");
		if !found break;
		if line.count == 0 continue;

		h += 1;
		w = line.count;

		for 0..line.count - 1 {
			c := line[it];
			
			if c == #char "S" {
				start = it + (h - 1) * w;
				terrain[it + (h - 1) * w] = 0;
			}
			else if c == #char "E" {
				end = it + (h - 1) * w;
				terrain[it + (h - 1) * w] = #char "z" - #char "a";
			}
			else terrain[it + (h - 1) * w] = c - #char "a";
		}
	}

	visited := NewArray(w * h, bool);

	open: [..] int;
	array_add(*open, end);
	open.count = 1;
	cursor := 0;

	prev := NewArray(w * h, int);
	for * prev { <<it = -1; }

	// BFS to find shortest path
	while cursor < open.count {
		x := open[cursor];
		cursor += 1;

		if visited[x] continue;
		visited[x] = true;

		if terrain[x] == 0 {
			start = x;
			break;
		}

		// Check all 4 directions
		for 0..3 {
			y := x;
			a := x % w;
			b := x / w;

			if it == 0 a -= 1;
			if it == 1 a += 1;
			if it == 2 b -= 1;
			if it == 3 b += 1;

			if a < 0 || a >= w continue;
			if b < 0 || b >= h continue;
			y = a + b * w;

			if visited[y] continue;
			if terrain[x] > terrain[y] + 1 continue;

			array_add(*open, y);
			prev[y] = x;
		}
	}

	// Reconstruct path
	path := NewArray(w * h, int);
	path.count = 0;
	x := start;
	while x != -1 {
		path.count += 1;
		path[path.count - 1] = x;
		x = prev[x];
	}

	return path.count - 1;
}

main :: () -> (int, int) {
	input, success :: #run read_entire_file("Inputs/12.txt");
	if !success {
		print("Error reading input\n");
		return (-1, -1);
	}

	return part1(input), part2(input);
}