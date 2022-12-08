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

	numbers: [..] int;
	array_reserve(*numbers, line.count);

	w := 0;
	h := 0;

	while true {
		found, line, rest = split_from_left(rest, #char "\n");
		if !found break;

		w = line.count;
		h += 1;

		for 0..w - 1 array_add(*numbers, line[it] - #char "0");
	}

	seen := NewArray(numbers.count, bool);
	for * seen { <<it = false; }

	max_on_edge :: (n: [] int, off: int, count: int, stride: int) -> int #expand {
		nn := 0;
		m := n[off];
		i := off;
		c := off + stride;
		for 1..count - 2 {
			if n[c] > m {
				m = n[c];
				i = c;
				if !seen[c] {
					seen[c] = true;
					nn += 1;
				}
			}
			c += stride;
		}
		return nn;
	}

	n := w - 1 + h - 1 + w - 1 + h - 1;
	for 1..w - 2 n += max_on_edge(numbers, it * w, w, 1);
	for 1..w - 2 n += max_on_edge(numbers, (it + 1) * w - 1, w, -1);
	for 1..h - 2 n += max_on_edge(numbers, w * (h - 1) + it, h, -w);
	for 1..h - 2 n += max_on_edge(numbers, it, h, w);
	return n;
}

part2 :: (input: string) -> int {
	found: bool;
	line: string;
	rest := input;

	numbers: [..] int;
	array_reserve(*numbers, line.count);

	w := 0;
	h := 0;

	while true {
		found, line, rest = split_from_left(rest, #char "\n");
		if !found break;

		w = line.count;
		h += 1;

		for 0..w - 1 array_add(*numbers, line[it] - #char "0");
	}

	compute_score :: (x: int, y: int) -> int #expand {

		H := numbers[x + y * w];

		left := 0;
		right := 0;
		up := 0;
		down := 0;

		for < x-1..0 {
			left += 1;
			if numbers[it + y * w] >= H break;
		}
		for x+1..w-1 {
			right += 1;
			if numbers[it + y * w] >= H break;
		}
		for < y-1..0 {
			up += 1;
			if numbers[x + it * w] >= H break;
		}
		for y+1..h-1 {
			down += 1;
			if numbers[x + it * w] >= H break;
		}

		return left * right * up * down;
	}

	max_score := 0;

	for y: 1..h - 2 {
		for x: 1..w - 2 {
			curr := compute_score(x, y);
			if curr > max_score max_score = curr;
		}
	}

	return max_score;
}

main :: () -> (int, int) {
	input, success :: #run read_entire_file("Inputs/08.txt");
	if !success {
		print("Error reading input\n");
		return (-1, -1);
	}

	return part1(input), part2(input);
}