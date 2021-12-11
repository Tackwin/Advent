#import "Basic";
#import "File";
#import "String";
#import "Sort";

dump :: (arr: [] int, w: int, h: int) {
	print("\n");
	for y: 0..h-1 {
		for x: 0..w-1 print("%", arr[x + y * w]);
		print("\n");
	}
	print("\n");
}

part1 :: (octopus : [] int, w: int, h: int) -> int {
	arr1 := octopus;

	n := 0;

	for s: 1..100 {

		for x: 0..w-1 for y: 0..h-1 arr1[x + y * w] += 1;

		while true {
			one := false;
			for x: 0..w-1 for y: 0..h-1 if arr1[x + y * w] > 9 {
				arr1[x + y * w] = -1;

				for x_off: x-1..x+1 for y_off: y-1..y+1
					if x_off >= 0 && x_off < w
					if y_off >= 0 && y_off < h
					if arr1[x_off + y_off * w] >= 0
				{
					arr1[x_off + y_off * w] += 1;
				}

				one = true;
				n += 1;
			}

			if !one break;

		}

		for x: 0..w-1 for y: 0..h-1 if arr1[x + y * w] < 0 arr1[x + y * w] = 0;
	}

	return n;
}

part2 :: (octopus : [] int, w: int, h: int) -> int {
	arr1 := octopus;


	for s: 1..50000 {
		n := 0;
	
		for x: 0..w-1 for y: 0..h-1 arr1[x + y * w] += 1;

		while true {
			one := false;
			for x: 0..w-1 for y: 0..h-1 if arr1[x + y * w] > 9 {
				arr1[x + y * w] = -1;

				for x_off: x-1..x+1 for y_off: y-1..y+1
					if x_off >= 0 && x_off < w
					if y_off >= 0 && y_off < h
					if arr1[x_off + y_off * w] >= 0
				{
					arr1[x_off + y_off * w] += 1;
				}

				one = true;
				n += 1;
			}

			if !one break;

		}

		for x: 0..w-1 for y: 0..h-1 if arr1[x + y * w] < 0 arr1[x + y * w] = 0;

		// wtf why the +100 ??????
		if n == w * h return s + 100;
	}
	return -1;
}

main :: () -> (int, int) {
	input, success := read_entire_file("Inputs/11.txt");
	if !success {
		print("Error reading input\n");
		return -1, -1;
	}

	lines := split(input, "\n");

	octopus : [..] int;
	w := lines[0].count;
	h := lines.count - 1;

	for lines if it.data {

		for c: 0..it.count-1 {
			array_add(*octopus, it[c] - #char "0");
		}
	}

	return part1(octopus, w, h), part2(octopus, w, h);
}