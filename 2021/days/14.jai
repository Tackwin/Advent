#import "Basic";
#import "File";
#import "String";
#import "Sort";
#import "Hash_Table";
#import "Hash";


Rule :: struct {
	before: string;
	insert: u8;
};

part1 :: (polymer: string, rules: [] Rule) -> int {
	front : [] u8;
	back : [..] u8;

	front.data = polymer.data;
	front.count = polymer.count;
	front = array_copy(front);

	match_rule :: (m: string, rules: [] Rule) -> *Rule {
		for * rules if it.before == m return it;
		return null;
	}

	for s: 0..9 {
		back.count = 0;
		for 0..front.count-2 {
			array_add(*back, front[it]);

			test : string;
			test.data = front.data + it;
			test.count = 2;

			rule := match_rule(test, rules);
			if rule array_add(*back, rule.insert);
		}
		array_add(*back, front[front.count - 1]);
		front = array_copy(back);
	}

	hist : [255] int;
	for * hist { <<it = 0; };

	for back hist[it] += 1;

	least := front.count;
	most := 0;

	for hist if it > 0 {
		least = min(least, it);
		most = max(most, it);
	}

	return most - least;
}

part2 :: (polymer: string, rules: [] Rule) -> int {
	Key :: struct {
		match: [2]u8;
		level: u8;
	};
	Hist :: [26] int;

	cmp :: (a: Key, b: Key) -> bool {
		return memcmp(*a, *b, size_of(Key)) == 0;
	}

	hsh :: (x: Key) -> u32 {
		return sdbm_hash(*x, size_of(Key));
	}

	match_rule :: (k: Key, rules: [] Rule) -> *Rule {
		for * rules
			if it.before[0] - #char "A" == k.match[0]
			if it.before[1] - #char "A" == k.match[1]
				return it;
		return null;
	}

	Cache :: Table(Key, Hist, hsh, cmp);
	cache: Cache;

	compute :: (k: Key, rules: [] Rule, h: *Hist, cache: *Cache) {
		if k.level == 0 return;

		found := table_find_pointer(<<cache, k);
		if found {
			for <<found { (<<h)[it_index] += it; }
			return;
		}

		r := match_rule(k, rules);
		if !r return;

		local_hist : Hist;
		local_hist[r.insert - #char "A"] += 1;

		a: Key;
		a.level = k.level - 1;

		a.match[0] = k.match[0];
		a.match[1] = r.insert - #char "A";
		compute(a, rules, *local_hist, cache);
		a.match[0] = r.insert - #char "A";
		a.match[1] = k.match[1];
		compute(a, rules, *local_hist, cache);

		table_set(cache, k, local_hist);

		for local_hist { (<<h)[it_index] += it; }

	};

	final_hist : Hist;
	final_hist[polymer[0] - #char "A"] += 1;
	for 0..polymer.count-2 {
		k: Key;
		k.level = 40;
		k.match[0] = polymer[it] - #char "A";
		k.match[1] = polymer[it + 1] - #char "A";

		hist : Hist;
		compute(k, rules, *hist, *cache);

		final_hist[k.match[1]] += 1;
		for hist final_hist[it_index] += it;
	}

	least := 1 << 62;
	most := 0;

	for final_hist if it > 0 least = min(least, it);
	for final_hist if it > 0 most = max(most, it);

	return most - least;
}

main :: () -> (int, int) {
	input, success := read_entire_file("Inputs/14.txt");
	if !success {
		print("Error reading input\n");
		return -1, -1;
	}

	lines := split(input, "\n");
	polymer := lines[0];
	rules: [..] Rule;

	for idx: 2..lines.count-1 {
		it := lines[idx];
		if !it.data continue;

		rule: Rule;
		rule.before = split(it, " -> ")[0];
		rule.insert = split(it, " -> ")[1][0];
		array_add(*rules, rule);
	}

	return part1(polymer, rules), part2(polymer, rules);
}