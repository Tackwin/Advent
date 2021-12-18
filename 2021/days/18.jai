#import "Basic";
#import "File";
#import "String";
#import "Sort";
#import "Hash_Table";
#import "Hash";

Pair :: struct {
	number := -1;

	left   : int;
	right  : int;
	parent := -1;
}

Pair_Pool :: [..] Pair;

dump_pair :: (pairs : [] Pair, n: int) {
	p := pairs[n];

	if p.number >= 0 {
		print("%", p.number);
		return;
	}

	print("[");
	dump_pair(pairs, p.left);
	print(",");
	dump_pair(pairs, p.right);
	print("]");
}

add :: (a: *Pair_Pool, b: Pair_Pool) {
	root : Pair;
	root.number = -1;
	root.left  = find_root(<<a);
	root.right = a.count + find_root(b);

	off := a.count;
	for b {
		new := it;
		if new.left   >= 0 new.left   += xx off;
		if new.right  >= 0 new.right  += xx off;
		if new.parent >= 0 new.parent += xx off;

		array_add(a, new);
	}

	// set both previous root to the futur new root.
	(<<a)[find_root(<<a)].parent = a.count;
	(<<a)[find_root(<<a)].parent = a.count;

	array_add(a, root);
}

explode :: (a: *Pair_Pool) -> bool {
	help :: (a: *Pair_Pool, pair: int, level: int) -> bool {
		it := (<<a)[pair];
		if it.number < 0 {
			if help(a, it.left, level + 1) return true;
			if help(a, it.right, level + 1) return true;
		}

		if it.number < 0 && level > 4 {
			prev := it.parent;

			ancestor_idx := pair;
			ancestor := (<<a)[ancestor_idx];
			old := ancestor_idx;

			// Look for the first ancestor that has it as a right descendant
			while ancestor.parent >= 0 {
				old = ancestor_idx;
				ancestor_idx = ancestor.parent;
				ancestor = (<<a)[ancestor_idx];

				if ancestor.left != old break;
			}

			// if we found we get the rightmost child from this node.
			if ancestor.left != old {

				neigboor_idx := ancestor.left;
				neigboor := (<<a)[neigboor_idx];

				while neigboor.number < 0 && neigboor.right >= 0 {
					neigboor_idx = neigboor.right;
					neigboor = (<<a)[neigboor_idx];
				}

				(<<a)[neigboor_idx].number += (<<a)[it.left].number;
			}

			
			ancestor_idx = pair;
			ancestor = (<<a)[ancestor_idx];
			old = ancestor_idx;

			// Look for the first ancestor that has it as a left descendant
			while ancestor.parent >= 0 {
				old = ancestor_idx;
				ancestor_idx = ancestor.parent;
				ancestor = (<<a)[ancestor_idx];

				if ancestor.right != old break;
			}

			// if we found we get the leftmost child from this node.
			if ancestor.right != old {

				neigboor_idx := ancestor.right;
				neigboor := (<<a)[neigboor_idx];

				while neigboor.number < 0 && neigboor.left >= 0 {
					neigboor_idx = neigboor.left;
					neigboor = (<<a)[neigboor_idx];
				}

				(<<a)[neigboor_idx].number += (<<a)[it.right].number;
			}

			// anyway we change what was a pair to the number 0.
			(<<a)[pair].number = 0;

			return true;
		}

		return false;
	}

	return help(a, find_root(<<a), 1);
}

split :: (a: *Pair_Pool) -> bool {
	help :: (a: *Pair_Pool, pair: int) -> bool {
		it := *(<<a)[pair];
		if it.number < 0 {
			if help(a, it.left) return true;
			if help(a, it.right) return true;
		}

		if it.number > 9 {
			n := it.number;

			it.number = -1;
			it.left = a.count;
			it.right = a.count + 1;

			left : Pair;
			left.number = n / 2;
			left.parent = pair;
			array_add(a, left);

			right : Pair;
			right.number = (1 + n) / 2;
			right.parent = pair;
			array_add(a, right);

			return true;
		}

		return false;
	}

	return help(a, find_root(<<a));
}


find_root :: (pairs : Pair_Pool) -> int {
	for pairs if it.parent < 0 return it_index;
	return -1;
}


magnitude :: (pairs : Pair_Pool, pair: int) -> int {
	it := pairs[pair];

	if it.number >= 0 return it.number;
	return 3 * magnitude(pairs, it.left) + 2 * magnitude(pairs, it.right);
}


all_sum :: (pairs : Pair_Pool, pair: int) -> int {
	it := pairs[pair];
	if it.number >= 0 return it.number;
	return all_sum(pairs, it.left) + all_sum(pairs, it.right);
}

max_depth :: (pairs : Pair_Pool, pair: int) -> int {
	it := pairs[pair];
	if it.number >= 0 return 0;
	return 1 + max(max_depth(pairs, it.left), max_depth(pairs, it.right));
}

part1 :: (pairs: [] Pair_Pool) -> int {
	if pairs.count == 0 return 0;

	sum : Pair_Pool;
	for pairs[0] array_add(*sum, it);
	for 1..pairs.count-1 {
		p := pairs[it];

		add(*sum, p);

		while true {
			if explode(*sum) continue;
			if split(*sum) continue;
			break;
		}
	}

	return magnitude(sum, find_root(sum));
}

part2 :: (pairs: [] Pair_Pool) -> int {
	max_m := 0;

	sum : Pair_Pool;
	for x, x_idx : pairs for y, y_idx : pairs if x_idx != y_idx {
		sum.count = 0;

		for x array_add(*sum, it);
		add(*sum, y);

		while true {
			if explode(*sum) continue;
			if split(*sum) continue;
			break;
		}

		max_m = max(magnitude(sum, find_root(sum)), max_m);
	}

	return max_m;
}

main :: () -> (int, int) {
	input, success := read_entire_file("Inputs/18.txt");
	if !success {
		print("Error reading input\n");
		return -1, -1;
	}

	lines := split(input, "\n");


	parse_pair :: (line: string, pairs: *[..] Pair) -> (parsed: int, new_pair: u64) {
		new_pair : Pair;
		
		if find_index_from_left("0123456789", line[0]) >= 0 {
			new_pair.number = line[0] - #char "0";

			array_add(pairs, new_pair);
			return 1, xx (pairs.count - 1);
		}
		
		assert(line[0] == #char "[");
		idx := 1;

		sub : string;
		sub.count = line.count - idx;
		sub.data = line.data + idx;

		left_parsed, left_pair := parse_pair(sub, pairs);
		idx += left_parsed;

		assert(line[idx] == #char ",");
		idx += 1;

		sub.count = line.count - idx;
		sub.data = line.data + idx;

		right_parsed, right_pair := parse_pair(sub, pairs);
		idx += right_parsed;

		assert(line[idx] == #char "]");
		idx += 1;

		new_pair.left = xx left_pair;
		new_pair.right = xx right_pair;

		(<<pairs)[new_pair.left].parent  = pairs.count;
		(<<pairs)[new_pair.right].parent = pairs.count;

		array_add(pairs, new_pair);
		return idx, xx (pairs.count - 1);
	}


	pair_pools : [..] Pair_Pool;

	for lines if it.data {
		pool : Pair_Pool;
		parse_pair(it, *pool);

		array_add(*pair_pools, pool);
	}


	return part1(pair_pools), part2(pair_pools);
}