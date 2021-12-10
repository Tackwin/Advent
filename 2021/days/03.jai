
#import "Basic";
#import "File";
#import "String";

part1 :: (lines: [] string) -> int {
	if lines.count == 0 return 0;

	e := 0;
	g := 0;

	for 0..lines[0].count-1 {
		n := 0;

		for line: lines if line.data && line[line.count - 1 - it] == #char "1" n += 1;

		if n * 2 >= lines.count e |= 1 << it;
		else                   g |= 1 << it;
	}

	return e * g;
}

part2 :: (lines: [] string) -> int {

	mask : [..]bool;
	for lines array_add(*mask, true);
	mask[mask.count - 1] = false;
	defer array_free(mask);

	o2 := "";
	co2 := "";

	for 0..lines[0].count - 1 {

		n := 0;
		all := 0;
		for i: 0..lines.count-1 if mask[i] {
			if lines[i].data && lines[i][it] == #char "1"
				n += 1;
			all += 1;
		}

		c := #char "0";
		if n * 2 >= all c  = #char "1";

		for i: 0..lines.count-1 if lines[i].data {
			mask[i] &= lines[i][it] == c;
		}

		n = 0;
		last := 0;
		for mask {
			if it { n += 1; last = it_index; }
			if n > 1 break;
		}



		if n == 1 {
			o2 = lines[last];
			break;
		}
	}

	for mask mask[it_index] = true;
	mask[mask.count - 1] = false;

	for 0..lines[0].count - 1 {

		n := 0;
		all := 0;
		for i: 0..lines.count-1 if mask[i] {
			if lines[i].data && lines[i][it] == #char "1"
				n += 1;
			all += 1;
		}

		c := #char "1";
		if n * 2 >= all c  = #char "0";

		for i: 0..lines.count-1 if lines[i].data {
			mask[i] &= lines[i][it] == c;
		}

		n = 0;
		last := 0;
		for mask {
			if it { n += 1; last = it_index; }
			if n > 1 break;
		}


		if n == 1 {
			co2 = lines[last];
			break;
		}
	}


	a := 0;
	b := 0;
	for 0..o2.count-1 if o2[it] == #char "1" a |= 1 << (o2.count - 1 - it);
	for 0..co2.count-1 if co2[it] == #char "1" b |= 1 << (co2.count - 1 - it);

	return a * b;
}

main :: () -> (int, int) {
	input, success := read_entire_file("Inputs/03.txt");
	if !success {
		print("Error reading input\n");
		return -1, -1;
	}

	lines := split(input, "\n");


	return part1(lines), part2(lines);
}