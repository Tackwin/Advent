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

Sensor :: struct {
	pos: V2;
	range: V2;
}

#scope_export
part1 :: (input: string) -> int {
	found: bool;
	line: string;
	rest := input;

	sensors: [..] Sensor;

	while true {
		found, line, rest = split_from_left(rest, #char "\n");
		if !found break;

		sensor: Sensor;
		if !scan2(
			line,
			"Sensor at x=%, y=%: closest beacon is at x=%, y=%",
			*sensor.pos.x, *sensor.pos.y, *sensor.range.x, *sensor.range.y
		) {
			continue;
		}


		// sensor.range.x = abs(sensor.range.x - sensor.pos.x);
		// sensor.range.y = abs(sensor.range.y - sensor.pos.y);
		array_add(*sensors, sensor);
	}

	mi: V2;
	ma: V2;
	mi.x = +S64_MAX;
	mi.y = +S64_MAX;
	ma.x = -S64_MAX;
	ma.y = -S64_MAX;
	for sensors {
		if it.pos.x < mi.x {
			mi.x = it.pos.x;
		}
		if it.pos.y < mi.y {
			mi.y = it.pos.y;
		}
		if it.pos.x > ma.x {
			ma.x = it.pos.x;
		}
		if it.pos.y > ma.y {
			ma.y = it.pos.y;
		}
		if it.range.x < mi.x {
			mi.x = it.range.x;
		}
		if it.range.y < mi.y {
			mi.y = it.range.y;
		}
		if it.range.x > ma.x {
			ma.x = it.range.x;
		}
		if it.range.y > ma.y {
			ma.y = it.range.y;
		}
	}

	n := 0;
	do :: (y: int) #expand {
		for x: -5000000..+5000000 {
			for sensors {
				if x == it.range.x && y == it.range.y break;
				if abs(x - it.pos.x) + abs(y - it.pos.y) <= abs(it.pos.x - it.range.x) + abs(it.pos.y - it.range.y) {
					n += 1;
					continue x;
				}
			}
		}
	}
	do(2_000_000);

	return n;
}

part2 :: (input: string) -> int {
	found: bool;
	line: string;
	rest := input;

	sensors: [..] Sensor;

	while true {
		found, line, rest = split_from_left(rest, #char "\n");
		if !found break;

		sensor: Sensor;
		if !scan2(
			line,
			"Sensor at x=%, y=%: closest beacon is at x=%, y=%",
			*sensor.pos.x, *sensor.pos.y, *sensor.range.x, *sensor.range.y
		) {
			continue;
		}

		array_add(*sensors, sensor);
	}

	mi: V2;
	ma: V2;
	mi.x = +S64_MAX;
	mi.y = +S64_MAX;
	ma.x = -S64_MAX;
	ma.y = -S64_MAX;
	for sensors {
		if it.pos.x < mi.x {
			mi.x = it.pos.x;
		}
		if it.pos.y < mi.y {
			mi.y = it.pos.y;
		}
		if it.pos.x > ma.x {
			ma.x = it.pos.x;
		}
		if it.pos.y > ma.y {
			ma.y = it.pos.y;
		}
		if it.range.x < mi.x {
			mi.x = it.range.x;
		}
		if it.range.y < mi.y {
			mi.y = it.range.y;
		}
		if it.range.x > ma.x {
			ma.x = it.range.x;
		}
		if it.range.y > ma.y {
			ma.y = it.range.y;
		}
	}

	n := 0;
	do :: (y: int) -> int #expand {
		x := 0;
		while outer := x < 4_000_000 {
			for sensors {
				if x == it.range.x && y == it.range.y {
					x += 1;
					continue outer;
				}

				r := abs(it.pos.x - it.range.x) + abs(it.pos.y - it.range.y);

				if it.pos.x - (r - abs(y - it.pos.y)) <= x && x <= it.pos.x + (r - abs(y - it.pos.y)) {
					x = it.pos.x + (r - abs(y - it.pos.y)) + 1;
					continue outer;
				}
			}

			return x * 4_000_000 + y;
		}
		return -1;
	}
	for y: 0..4000000-1 {
		c := do(y);
		if c >= 0 {
			return c;
		}
	}

	return -1;
}

main :: () -> (int, int) {
	input, success :: #run read_entire_file("Inputs/15.txt");
	if !success {
		print("Error reading input\n");
		return (-1, -1);
	}

	return part1(input), part2(input);
}