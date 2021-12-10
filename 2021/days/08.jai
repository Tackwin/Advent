#import "Basic";
#import "File";
#import "String";

Input :: struct {
	pattern : [10] string;
	output : [4] string;
};

part1 :: (inputs : [] Input) -> int {
	n := 0;

	for inp: inputs {
		for inp.output if it.count == 2 || it.count == 4 || it.count == 3 || it.count == 7 n += 1;
	}

	return n;
}

// a-cdefg
part2 :: (inputs : [] Input) -> int {
	n := 0;

	find :: (arr: [] int, x: int) -> int {
		for arr if it == x return it_index;
		return -1;
	};

	hit_mask_to_digit :: (hit: [] bool) -> int {
		if hit[0] && hit[1] && hit[2] && !hit[3] && hit[4] && hit[5] && hit[6]
			return 0;
		if !hit[0] && !hit[1] && hit[2] && !hit[3] && !hit[4] && hit[5] && !hit[6]
			return 1;
		if hit[0] && !hit[1] && hit[2] && hit[3] && hit[4] && !hit[5] && hit[6]
			return 2;
		if hit[0] && !hit[1] && hit[2] && hit[3] && !hit[4] && hit[5] && hit[6]
			return 3;
		if !hit[0] && hit[1] && hit[2] && hit[3] && !hit[4] && hit[5] && !hit[6]
			return 4;
		if hit[0] && hit[1] && !hit[2] && hit[3] && !hit[4] && hit[5] && hit[6]
			return 5;
		if hit[0] && hit[1] && !hit[2] && hit[3] && hit[4] && hit[5] && hit[6]
			return 6;
		if hit[0] && !hit[1] && hit[2] && !hit[3] && !hit[4] && hit[5] && !hit[6]
			return 7;
		if hit[0] && hit[1] && hit[2] && hit[3] && hit[4] && hit[5] && hit[6]
			return 8;
		if hit[0] && hit[1] && hit[2] && hit[3] && !hit[4] && hit[5] && hit[6]
			return 9;

		return -1;
	}


	map : [7] int;
	for inp: inputs {
		pat := inp.pattern;
		for * map { <<it = -1; }

		for one: 0..pat.count-1 if pat[one].count == 2
		for sev: 0..pat.count-1 if pat[sev].count == 3 {
			if find_index_from_left(pat[one], pat[sev][0]) < 0
				map[0] = pat[sev][0] - #char "a";
			if find_index_from_left(pat[one], pat[sev][1]) < 0
				map[0] = pat[sev][1] - #char "a";
			if find_index_from_left(pat[one], pat[sev][2]) < 0
				map[0] = pat[sev][2] - #char "a";
		}

		for one: 0..pat.count-1 if pat[one].count == 2 for fou: 0..pat.count-1 if pat[fou].count == 4
		{
			inverse : [2] u8;
			n := 0;
			
			if find_index_from_left(pat[one], pat[fou][0]) < 0 {
				inverse[n] = pat[fou][0] - #char "a";
				n += 1;
			}
			if find_index_from_left(pat[one], pat[fou][1]) < 0 {
				inverse[n] = pat[fou][1] - #char "a";
				n += 1;
			}
			if find_index_from_left(pat[one], pat[fou][2]) < 0 {
				inverse[n] = pat[fou][2] - #char "a";
				n += 1;
			}
			if find_index_from_left(pat[one], pat[fou][3]) < 0 {
				inverse[n] = pat[fou][3] - #char "a";
				n += 1;
			}

			for fiv: 0..pat.count-1 if pat[fiv].count == 5
				if find_index_from_left(pat[fiv], cast(u8) (inverse[0] + #char "a")) >= 0
				if find_index_from_left(pat[fiv], cast(u8) (inverse[1] + #char "a")) >= 0 {
				
				if find_index_from_left(pat[fiv], pat[fou][0]) < 0 map[2] = pat[fou][0] - #char "a";
				if find_index_from_left(pat[fiv], pat[fou][1]) < 0 map[2] = pat[fou][1] - #char "a";
				if find_index_from_left(pat[fiv], pat[fou][2]) < 0 map[2] = pat[fou][2] - #char "a";
				if find_index_from_left(pat[fiv], pat[fou][3]) < 0 map[2] = pat[fou][3] - #char "a";
			}
		}

		for one: 0..pat.count-1 if pat[one].count == 2 {
			idx := find_index_from_left(pat[one], cast(u8) (map[2] + #char "a"));
			map[5] = pat[one][1 - idx] - #char "a";
		}

		for thr: 0..pat.count-1 if pat[thr].count == 5
		if find_index_from_left(pat[thr], cast(u8)(map[0] + #char "a")) >= 0
		if find_index_from_left(pat[thr], cast(u8)(map[2] + #char "a")) >= 0
		if find_index_from_left(pat[thr], cast(u8)(map[5] + #char "a")) >= 0 {

			dg : [2] u8;
			n := 0;

			for 0..pat[thr].count-1 if find(map, pat[thr][it] - #char "a") < 0 {
				dg[n] = cast(u8) (pat[thr][it] - #char "a");
				n += 1;
			}

			for fou: 0..pat.count-1 if pat[fou].count == 4 {
				found := find_index_from_left(pat[fou], dg[0] + #char "a") >= 0;
				if found {
					map[3] = dg[0];
					map[6] = dg[1];
				} else {
					map[3] = dg[1];
					map[6] = dg[0];
				}
			}
		}

		for nin: 0..pat.count-1
			if pat[nin].count == 6
			if find_index_from_left(pat[nin], cast(u8) (map[3] + #char "a")) >= 0
			if find_index_from_left(pat[nin], cast(u8) (map[2] + #char "a")) >= 0
		{
			if find_index_from_left(pat[nin], #char "a") < 0 map[4] = 0;
			if find_index_from_left(pat[nin], #char "b") < 0 map[4] = 1;
			if find_index_from_left(pat[nin], #char "c") < 0 map[4] = 2;
			if find_index_from_left(pat[nin], #char "d") < 0 map[4] = 3;
			if find_index_from_left(pat[nin], #char "e") < 0 map[4] = 4;
			if find_index_from_left(pat[nin], #char "f") < 0 map[4] = 5;
			if find_index_from_left(pat[nin], #char "g") < 0 map[4] = 6;
		}

		for 0..6 if find(map, it) < 0 map[1] = it;

		hit_mask : [7] bool;

		number := 0;
		mult := 1000;
		for out: inp.output {
			for * hit_mask if find_index_from_left(out, cast(u8) (map[it_index] + #char "a")) >= 0 {
				<<it = true;
			} else {
				<<it = false;
			}

			number += mult * hit_mask_to_digit(hit_mask);
			mult /= 10;
		}

		n += number;
	}

	return n;
}

main :: () -> (int, int) {
	input, success := read_entire_file("Inputs/08.txt");
	if !success {
		print("Error reading input\n");
		return -1, -1;
	}

	ages := split(input, "\n");
	inputs : [..] Input;
	array_reserve(*inputs, ages.count);

	for ages if it.data {
		temp_ := split(it, " | ");
		patterns := split(temp_[0], " ");
		outputs := split(temp_[1], " ");

		x : Input;
		for i: 0..9 x.pattern[i] = patterns[i];
		for i: 0..3 x.output[i] = outputs[i];

		array_add(*inputs, x);
	}
	
	return part1(inputs), part2(inputs);
}