#import "Basic";
#import "File";
#import "String";
#import "Sort";

part1 :: (heights : [] int, w: int, h: int) -> int {
	s := 0;
	for x: 0..w-1 for y: 0..h-1 {
		it := heights[x + y * w];

		if x > 0 && heights[x-1 + y * w] <= it continue;
		if x+1 < w && heights[x+1 + y * w] <= it continue;
		if y > 0 && heights[x + (y-1) * w] <= it continue;
		if y+1 < h && heights[x + (y+1) * w] <= it continue;

		s += it + 1;
	}
	
	return s;
}

part2 :: (heights : [] int, w: int, h: int) -> int {
	Point :: struct {
		x: int;
		y: int;
	};

	low_points : [..] Point;

	for x: 0..w-1 for y: 0..h-1 {
		it := heights[x + y * w];

		if x > 0 && heights[x-1 + y * w] <= it continue;
		if x+1 < w && heights[x+1 + y * w] <= it continue;
		if y > 0 && heights[x + (y-1) * w] <= it continue;
		if y+1 < h && heights[x + (y+1) * w] <= it continue;

		new_point : Point;
		new_point.x = x;
		new_point.y = y;
		array_add(*low_points, new_point);
	}

	flow_down :: (x: int, y: int, lows: []Point, heights: []int, w: int, h: int) -> int {
		for lows if it.x == x && it.y == y return it_index;

		it := heights[x + y * w];
		if it == 9 return -1;

		if x > 0 && heights[x-1 + y * w] < it return flow_down(x-1, y, lows, heights, w, h);
		if x+1 < w && heights[x+1 + y * w] < it return flow_down(x+1, y, lows, heights, w, h);
		if y > 0 && heights[x + (y-1) * w] < it return flow_down(x, y-1, lows, heights, w, h);
		if y+1 < h && heights[x + (y+1) * w] < it return flow_down(x, y+1, lows, heights, w, h);

		return -1;
	}
	
	bassins_sizes : [..] int;
	array_resize(*bassins_sizes, low_points.count);

	for x: 0..w-1 for y: 0..h-1 {
		b := flow_down(x, y, low_points, heights, w, h);
		if b >= 0 bassins_sizes[b] += 1;
	}

	quick_sort(bassins_sizes, x => x);

	a := 0;
	b := 0;
	c := 0;

	for bassins_sizes {
		if it >= a {
			c = b;
			b = a;
			a = it;
		}
	}

	return a * b * c;
}

main :: () -> (int, int) {
	input, success := read_entire_file("Inputs/09.txt");
	if !success {
		print("Error reading input\n");
		return -1, -1;
	}

	lines := split(input, "\n");
	heights : [..] int;
	array_reserve(*heights, lines[0].count * lines[0].count);

	for lines if it.data for c: 0..it.count-1 {
		array_add(*heights, it[c] - #char "0");
	}
	
	return
		part1(heights, lines[0].count, lines.count - 1),
		part2(heights, lines[0].count, lines.count - 1);
}