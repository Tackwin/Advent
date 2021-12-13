#import "Basic";
#import "File";
#import "String";
#import "Sort";
#import "Hash_Table";

Fold :: struct {
	is_x := false;
	value : int;
};

dump_sheet :: (sheet: [] int, w: int, h: int, stride: int) {
	for y: 0..h-1 {
		for x: 0..w-1 {
			print("%", ifx sheet[x + y * stride] > 0 "X" else " ");
		}
		print("\n");
	}
	print("\n");
}

part1 :: (sheet: [] int, sheet_w: int, sheet_h: int, folds: [] Fold) -> int {
	folded := array_copy(sheet);
	w := sheet_w;
	h := sheet_h;

	for f: folds {
		if f.is_x {
			for y: 0..h-1 for x: f.value..w-1 {
				folded_x := (f.value - (x - f.value));
				folded[folded_x + y * sheet_w] += folded[x + y * sheet_w];
			}

			w = f.value;
		} else {
			for y: f.value..h-1 for x: 0..w-1 {
				folded_y := (f.value - (y - f.value));
				folded[x + folded_y * sheet_w] += folded[x + y * sheet_w];
			}

			h = f.value;
		}
		break;
	}

	n := 0;
	for x: 0..w-1 for y: 0..h-1 if folded[x + y * sheet_w] > 0 n += 1;

	return n;
}

part2 :: (sheet: [] int, sheet_w: int, sheet_h: int, folds: [] Fold) -> int {
	folded := array_copy(sheet);
	w := sheet_w;
	h := sheet_h;

	for f: folds {
		if f.is_x {
			for y: 0..h-1 for x: f.value..w-1 {
				folded_x := (f.value - (x - f.value));
				folded[folded_x + y * sheet_w] += folded[x + y * sheet_w];
			}

			w = f.value;
		} else {
			for y: f.value..h-1 for x: 0..w-1 {
				folded_y := (f.value - (y - f.value));
				folded[x + folded_y * sheet_w] += folded[x + y * sheet_w];
			}

			h = f.value;
		}
	}
	print("\n");
	dump_sheet(folded, w, h, sheet_w);

	n := 0;
	for x: 0..w-1 for y: 0..h-1 if folded[x + y * sheet_w] > 0 n += 1;

	return n;
}

main :: () -> (int, int) {
	input, success := read_entire_file("Inputs/13.txt");
	if !success {
		print("Error reading input\n");
		return -1, -1;
	}

	lines := split(input, "\n");

	values : [..] int;
	for lines if it.data {
		x, success, __ := to_integer(split(it, ",")[0]);
		if !success break;

		array_add(*values, x);
		x, success, __ = to_integer(split(it, ",")[1]);
		if !success break;

		array_add(*values, x);
	}

	max_x := 0;
	max_y := 0;
	for 0..values.count/2-1 max_x = ifx max_x > values[it * 2] max_x else values[it * 2];
	for 0..values.count/2-1 max_y = ifx max_y > values[it * 2 + 1] max_y else values[it * 2 + 1];

	max_x += 1;
	max_y += 1;

	sheet : [..] int;
	array_resize(*sheet, max_x * max_y);
	for 0..values.count/2 - 1 {
		x := values[it * 2 + 0];
		y := values[it * 2 + 1];

		sheet[x + y * max_x] = 1;
	}

	folds : [..] Fold;
	for lines if it.data && it.count > 13 {
		idx := find_index_from_left(it, "=");
		idx += 1;

		f: Fold;
		if it[idx - 2] == #char "x" f.is_x = true;
		
		success : bool;
		rest : string;
		rest.data = it.data + idx;
		rest.count = it.count - idx;

		f.value, success, rest = to_integer(rest);

		array_add(*folds, f);
	}

	return
		part1(sheet, max_x, max_y, folds),
		part2(sheet, max_x, max_y, folds);
}