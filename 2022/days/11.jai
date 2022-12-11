#scope_file
#import "Basic";
#import "File";
#import "Sort";
#import "String";

Operation :: enum {
	Add;
	Mul;
	Sqr;
}

Monkey :: struct {
	queue: [..] int;
	op: Operation;
	arg: int;

	divisor: int;
	monkey_true: int;
	monkey_false: int;

	n_inspected := 0;
}

#scope_export
part1 :: (input: string) -> int {
	found: bool;
	line: string;
	rest := input;

	n_monkeys := 0;

	while true {
		found, line, rest = split_from_left(rest, #char "\n");
		if !found break;

		if starts_with(line, "Monkey") n_monkeys += 1;
	}

	monkeys := NewArray(n_monkeys, Monkey);

	rest = input;
	while true {
		found, line, rest = split_from_left(rest, #char "\n");
		if !found break;
		if line.count == 0 continue;

		monkey_idx := 0;
		if !scan2(line, "Monkey %:", *monkey_idx) continue;

		found, line, rest = split_from_left(rest, #char "\n");
		if !found continue;

		ok1, any1, number_list := split_from_right(line, #char ":");
		if !ok1 continue;
		number_lists := split(number_list, ",");
		for number_lists {
			s := trim(it);
			x: int;
			if !scan2(s, "%", *x) continue;
			array_add(*monkeys[monkey_idx].queue, x);
		}

		found, line, rest = split_from_left(rest, #char "\n");
		if !found continue;
		ok2, any2, op := split_from_right(line, #char "=");
		if !ok2 continue;
		op = trim(op);

		arg: int;
		if scan2(op, "old + %", *arg) {
			monkeys[monkey_idx].op = .Add;
			monkeys[monkey_idx].arg = arg;
		}
		else if scan2(op, "old * %", *arg) {
			monkeys[monkey_idx].op = .Mul;
			monkeys[monkey_idx].arg = arg;
		}
		else if scan2(op, "old * old") {
			monkeys[monkey_idx].op = .Sqr;
		}
		else {
			print("Unknown op: %\n", op);
			continue;
		}

		found, line, rest = split_from_left(rest, #char "\n");
		if !found continue;
		if !scan2(line, "  Test: divisible by %", *monkeys[monkey_idx].divisor) continue;

		found, line, rest = split_from_left(rest, #char "\n");
		if !found continue;

		if !scan2(line, "    If true: throw to monkey %", *monkeys[monkey_idx].monkey_true)
			continue;
		
		found, line, rest = split_from_left(rest, #char "\n");
		if !found continue;

		if !scan2(line, "    If false: throw to monkey %", *monkeys[monkey_idx].monkey_false)
			continue;
	}

	N_Rounds :: 20;
	for r: 0..N_Rounds - 1 {
		for * m: monkeys {
			for m.queue {
				m.n_inspected += 1;

				worry := it;
				if m.op == .Add worry += m.arg;
				if m.op == .Mul worry *= m.arg;
				if m.op == .Sqr worry *= worry;
				worry /= 3;

				if worry % m.divisor == 0 array_add(*monkeys[m.monkey_true].queue, worry);
				else                      array_add(*monkeys[m.monkey_false].queue, worry);
			}
			m.queue.count = 0;
		}
	}

	first := 0;
	first_idx := 0;
	for monkeys if it.n_inspected > first {
		first = it.n_inspected;
		first_idx = it_index;
	}

	second := 0;
	second_idx := 0;
	for monkeys if it.n_inspected > second && it_index != first_idx {
		second = it.n_inspected;
		second_idx = it_index;
	}

	return first * second;
}

part2 :: (input: string) -> int {
	found: bool;
	line: string;
	rest := input;

	n_monkeys := 0;

	while true {
		found, line, rest = split_from_left(rest, #char "\n");
		if !found break;

		if starts_with(line, "Monkey") n_monkeys += 1;
	}

	monkeys := NewArray(n_monkeys, Monkey);

	rest = input;
	while true {
		found, line, rest = split_from_left(rest, #char "\n");
		if !found break;
		if line.count == 0 continue;

		monkey_idx := 0;
		if !scan2(line, "Monkey %:", *monkey_idx) continue;

		found, line, rest = split_from_left(rest, #char "\n");
		if !found continue;

		ok1, any1, number_list := split_from_right(line, #char ":");
		if !ok1 continue;
		number_lists := split(number_list, ",");
		for number_lists {
			s := trim(it);
			x: int;
			if !scan2(s, "%", *x) continue;
			array_add(*monkeys[monkey_idx].queue, x);
		}

		found, line, rest = split_from_left(rest, #char "\n");
		if !found continue;
		ok2, any2, op := split_from_right(line, #char "=");
		if !ok2 continue;
		op = trim(op);

		arg: int;
		if scan2(op, "old + %", *arg) {
			monkeys[monkey_idx].op = .Add;
			monkeys[monkey_idx].arg = arg;
		}
		else if scan2(op, "old * %", *arg) {
			monkeys[monkey_idx].op = .Mul;
			monkeys[monkey_idx].arg = arg;
		}
		else if scan2(op, "old * old") {
			monkeys[monkey_idx].op = .Sqr;
		}
		else {
			print("Unknown op: %\n", op);
			continue;
		}

		found, line, rest = split_from_left(rest, #char "\n");
		if !found continue;
		if !scan2(line, "  Test: divisible by %", *monkeys[monkey_idx].divisor) continue;

		found, line, rest = split_from_left(rest, #char "\n");
		if !found continue;

		if !scan2(line, "    If true: throw to monkey %", *monkeys[monkey_idx].monkey_true)
			continue;
		
		found, line, rest = split_from_left(rest, #char "\n");
		if !found continue;

		if !scan2(line, "    If false: throw to monkey %", *monkeys[monkey_idx].monkey_false)
			continue;
	}

	composite_divisor := 1;
	for monkeys composite_divisor *= it.divisor;

	N_Rounds :: 10000;
	for r: 0..N_Rounds - 1 {
		for * m: monkeys {
			for m.queue {
				m.n_inspected += 1;

				worry := it;
				if m.op == .Add worry += m.arg;
				if m.op == .Mul worry *= m.arg;
				if m.op == .Sqr worry *= worry;
				worry %= composite_divisor;

				if worry % m.divisor == 0 array_add(*monkeys[m.monkey_true].queue, worry);
				else                      array_add(*monkeys[m.monkey_false].queue, worry);
			}
			m.queue.count = 0;
		}
	}

	first := 0;
	first_idx := 0;
	for monkeys if it.n_inspected > first {
		first = it.n_inspected;
		first_idx = it_index;
	}

	second := 0;
	second_idx := 0;
	for monkeys if it.n_inspected > second && it_index != first_idx {
		second = it.n_inspected;
		second_idx = it_index;
	}

	return first * second;
}

main :: () -> (int, int) {
	input, success :: #run read_entire_file("Inputs/11.txt");
	if !success {
		print("Error reading input\n");
		return (-1, -1);
	}

	return part1(input), part2(input);
}