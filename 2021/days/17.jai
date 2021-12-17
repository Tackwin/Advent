#import "Basic";
#import "File";
#import "String";
#import "Sort";
#import "Hash_Table";
#import "Hash";

part1 :: (x: int, y: int, w: int, h: int) -> int {

	test :: (x: int, y: int, w: int, h: int, px: int, py: int) -> bool {
		return x <= px && px <= w && y <= py && py <= h;
	}

	max_h := 0;
	for start_vx: 0..1000 for start_vy: -1000..1000 {

		vx := start_vx;
		vy := start_vy;
		px := 0;
		py := 0;

		maxy := 0;

		while py >= y {
			maxy = max(maxy, py);

			if test(x, y, w, h, px, py) {
				max_h = max(maxy, max_h);
				break;
			}

			px += vx;
			py += vy;

			vx -= 1;
			vx = max(0, vx);
			vy -= 1;
		}
	}

	return max_h;
}

part2 :: (x: int, y: int, w: int, h: int) -> int {
	test :: (x: int, y: int, w: int, h: int, px: int, py: int) -> bool {
		return x <= px && px <= w && y <= py && py <= h;
	}

	n := 0;
	
	for start_vx: 0..1000 for start_vy: -1000..1000 {
		vx := start_vx;
		vy := start_vy;
		px := 0;
		py := 0;

		while py >= y {
			if test(x, y, w, h, px, py) {
				n += 1;
				// print("% %\n", start_vx, start_vy);
				break;
			}

			px += vx;
			py += vy;

			vx -= 1;
			vx = max(0, vx);
			vy -= 1;
		}
	}

	return n;
}

main :: () -> (int, int) {
	input, success := read_entire_file("Inputs/17.txt");
	if !success {
		print("Error reading input\n");
		return -1, -1;
	}

	return part1(88, -157, 125, -103), part2(88, -157, 125, -103);
}