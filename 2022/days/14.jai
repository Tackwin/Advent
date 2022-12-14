#scope_file
#import "Basic";
#import "File";
#import "Sort";
#import "String";
#import "Math";

V2 :: struct {
	x: int;
	y: int;
}

drop :: (v: V2, grid: [] int, x: int, y: int, w: int, h: int) -> bool {
	curr := V2.{500, 0};

	blocked :: (v: V2) -> bool #expand {
		return grid[(v.y - y) * w + (v.x - x)] != 0;
	}

	while curr.y + 1 < h + y {
		if !blocked(.{ curr.x + 0, curr.y + 1 }) {
			curr.y += 1;
			continue;
		}
		if !blocked(.{ curr.x - 1, curr.y + 1 }) {
			curr.y += 1;
			curr.x -= 1;
			continue;
		}
		if !blocked(.{ curr.x + 1, curr.y + 1 }) {
			curr.y += 1;
			curr.x += 1;
			continue;
		}
		grid[(curr.y - y) * w + (curr.x - x)] = 2;
		return true;
	}

	return false;
}
drop2 :: (v: V2, grid: [] int, x: int, y: int, w: int, h: int) -> bool {
	curr := V2.{500, 0};

	blocked :: (v: V2) -> bool #expand {
		if v.y - y >= h return true;
		return grid[(v.y - y) * w + (v.x - x)] != 0;
	}

	while curr.y + 1 < h + y {
		if !blocked(.{ curr.x + 0, curr.y + 1 }) {
			curr.y += 1;
			continue;
		}
		if !blocked(.{ curr.x - 1, curr.y + 1 }) {
			curr.y += 1;
			curr.x -= 1;
			continue;
		}
		if !blocked(.{ curr.x + 1, curr.y + 1 }) {
			curr.y += 1;
			curr.x += 1;
			continue;
		}
		grid[(curr.y - y) * w + (curr.x - x)] = 2;
		return curr.x != 500 || curr.y != 0;
	}

	grid[(curr.y - y) * w + (curr.x - x)] = 2;
	return true;
}

#scope_export
part1 :: (input: string) -> int {
	found: bool;
	line: string;
	rest := input;

	input_coords: [..] V2;
	stops: [..] int;

	while true {
		found, line, rest = split_from_left(rest, #char "\n");
		if !found break;

		coords := split(line, " -> ");

		array_add(*stops, input_coords.count);
		for coords {
			v: V2;
			if !scan2(it, "%,%", *v.x, *v.y) continue;
			array_add(*input_coords, v);
		}
	}
	array_add(*stops, input_coords.count);

	mi: V2;
	ma: V2;
	mi.x = 499;
	mi.y = -1;
	ma.x = 501;
	ma.y = 1;
	for input_coords {
		mi.x = min(mi.x, it.x - 1);
		mi.y = min(mi.y, it.y - 1);
		ma.x = max(ma.x, it.x + 1);
		ma.y = max(ma.y, it.y + 1);
	}

	w := ma.x - mi.x + 1;
	h := ma.y - mi.y + 1;
	grid := NewArray(w * h, int);
	for * grid { <<it = 0; }

	for 0..stops.count-2 {
		curr := input_coords[stops[it]];
		for stops[it] + 1..stops[it+1] - 1 {
			targets := input_coords[it];

			while curr.x != targets.x || curr.y != targets.y {
				grid[(curr.y - mi.y) * w + (curr.x - mi.x)] = 1;

				if curr.x < targets.x {
					curr.x += 1;
				} else if curr.x > targets.x {
					curr.x -= 1;
				} else if curr.y < targets.y {
					curr.y += 1;
				} else if curr.y > targets.y {
					curr.y -= 1;
				}
			}
			grid[(curr.y - mi.y) * w + (curr.x - mi.x)] = 1;
		}
	}

	n := 0;
	while drop(.{500, 0}, grid, mi.x, mi.y, w, h) n += 1;

	return n;
}

part2 :: (input: string) -> int {
	found: bool;
	line: string;
	rest := input;

	input_coords: [..] V2;
	stops: [..] int;

	while true {
		found, line, rest = split_from_left(rest, #char "\n");
		if !found break;

		coords := split(line, " -> ");

		array_add(*stops, input_coords.count);
		for coords {
			v: V2;
			if !scan2(it, "%,%", *v.x, *v.y) continue;
			array_add(*input_coords, v);
		}
	}
	array_add(*stops, input_coords.count);

	mi: V2;
	ma: V2;
	mi.x = 499;
	mi.y = -1;
	ma.x = 501;
	ma.y = 1;
	for input_coords {
		mi.x = min(mi.x, it.x - 1);
		mi.y = min(mi.y, it.y - 1);
		ma.x = max(ma.x, it.x + 1);
		ma.y = max(ma.y, it.y + 1);
	}

	w := ma.x - mi.x + 1;
	h := ma.y - mi.y + 1;
	w = max(w, 2 * h);
	mi.x = min(mi.x, 500 - h);
	grid := NewArray(w * h, int);

	for * grid { <<it = 0; }

	for 0..stops.count-2 {
		curr := input_coords[stops[it]];
		for stops[it] + 1..stops[it+1] - 1 {
			targets := input_coords[it];

			while curr.x != targets.x || curr.y != targets.y {
				grid[(curr.y - mi.y) * w + (curr.x - mi.x)] = 1;

				if curr.x < targets.x {
					curr.x += 1;
				} else if curr.x > targets.x {
					curr.x -= 1;
				} else if curr.y < targets.y {
					curr.y += 1;
				} else if curr.y > targets.y {
					curr.y -= 1;
				}
			}
			grid[(curr.y - mi.y) * w + (curr.x - mi.x)] = 1;
		}
	}

	n := 0;
	while drop2(.{500, 0}, grid, mi.x, mi.y, w, h) n += 1;

	return n + 1;
}

main :: () -> (int, int) {
	input, success :: #run read_entire_file("Inputs/14.txt");
	if !success {
		print("Error reading input\n");
		return (-1, -1);
	}

	return part1(input), part2(input);
}