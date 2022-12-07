#scope_file
#import "Basic";
#import "File";
#import "Sort";
#import "String";

Node :: struct {
	parent := -1;
	name: string;
	is_dir := false;
	size := 0;

	nodes: [..] int;
}

print :: (nodes: [] Node, x: int, tabs: int) {
	for 0..tabs-1 print("\t");
	if nodes[x].is_dir {
		print("- % (dir)\n", nodes[x].name);
	} else {
		print ("- % (file, size=%)\n", nodes[x].name, nodes[x].size);
	}

	for nodes[x].nodes print(nodes, it, tabs + 1);
}

compute_size :: (nodes: [] Node, x: int, tabs: int) -> int {
	it := *nodes[x];
	if !it.is_dir return it.size;

	for c: nodes[x].nodes it.size += compute_size(nodes, c, tabs + 1);
	return it.size;
}

#scope_export
part1 :: (input: string) -> int {
	found: bool;
	line: string;
	rest := input;

	nodes: [..] Node;
	current := 0;

	root: Node;
	root.name = "";
	root.is_dir = true;
	array_add(*nodes, root);

	while true {
		found, line, rest = split_from_left(rest, #char "\n");
		if !found break;

		if compare(line, "$ cd /") == 0 {
			current = 0;

			continue;
		}

		if compare(line, "$ ls") == 0 {
			out: string;
			while true {
				found, out, rest = split_from_left(rest, #char "\n");
				if !found break;
				if begins_with(out, "$") {
					// Don't forget to back track the just eaten line !!
					rest.data -= out.count + 1;
					rest.count += out.count + 1;
					break;
				}

				name: string;
				size: int;

				if begins_with(out, "dir ") {
					new: Node;
					new.parent = current;
					new.name = slice(out, 4, out.count - 4);
					new.is_dir = true;
					array_add(*nodes, new);
					array_add(*nodes[current].nodes, nodes.count - 1);
				} else {
					tokens := split(out, " ");
					
					new: Node;
					new.parent = current;
					new.name = tokens[1];
					new.is_dir = false;
					scan2(tokens[0], "%", *new.size);
					array_add(*nodes, new);
					array_add(*nodes[current].nodes, nodes.count - 1);
				}
			}

			continue;
		}

		if begins_with(line, "$ cd ") {
			arg := slice(line, 5, line.count - 5);
			if compare(arg, "..") == 0 {
				if nodes[current].parent >= 0 current = nodes[current].parent;
				if current < 0 break;

				continue;
			} else {
				for nodes[current].nodes if compare(nodes[it].name, arg) == 0 {
					current = it;
					break;
				}
				continue;
 			}
		}
	}
	compute_size(nodes, 0, 0);

	solve :: (nodes: [] Node, x: int) -> int {
		it := nodes[x];

		sum := 0;
		if it.is_dir {
			if it.size <= 100000 sum += it.size;
			for c: it.nodes sum += solve(nodes, c);
		}
		return sum;
	}

	return solve(nodes, 0);
}

part2 :: (input: string) -> int {
	found: bool;
	line: string;
	rest := input;

	nodes: [..] Node;
	current := 0;

	root: Node;
	root.name = "";
	root.is_dir = true;
	array_add(*nodes, root);

	while true {
		found, line, rest = split_from_left(rest, #char "\n");
		if !found break;

		if compare(line, "$ cd /") == 0 {
			current = 0;

			continue;
		}

		if compare(line, "$ ls") == 0 {
			out: string;
			while true {
				found, out, rest = split_from_left(rest, #char "\n");
				if !found break;
				if begins_with(out, "$") {
					// Don't forget to back track the just eaten line !!
					rest.data -= out.count + 1;
					rest.count += out.count + 1;
					break;
				}

				name: string;
				size: int;

				if begins_with(out, "dir ") {
					new: Node;
					new.parent = current;
					new.name = slice(out, 4, out.count - 4);
					new.is_dir = true;
					array_add(*nodes, new);
					array_add(*nodes[current].nodes, nodes.count - 1);
				} else {
					tokens := split(out, " ");
					
					new: Node;
					new.parent = current;
					new.name = tokens[1];
					new.is_dir = false;
					scan2(tokens[0], "%", *new.size);
					array_add(*nodes, new);
					array_add(*nodes[current].nodes, nodes.count - 1);
				}
			}

			continue;
		}

		if begins_with(line, "$ cd ") {
			arg := slice(line, 5, line.count - 5);
			if compare(arg, "..") == 0 {
				if nodes[current].parent >= 0 current = nodes[current].parent;
				if current < 0 break;

				continue;
			} else {
				for nodes[current].nodes if compare(nodes[it].name, arg) == 0 {
					current = it;
					break;
				}
				continue;
 			}
		}
	}
	compute_size(nodes, 0, 0);

	total_size := 70000000;
	total_size -= nodes[0].size;

	to_look := 30000000 - total_size;

	solve :: (nodes: [] Node, x: int, best: int, target: int) -> int {
		it := nodes[x];

		if it.is_dir {
			if it.size >= target && it.size < best {
				best = it.size;
			}

			for c: it.nodes best = solve(nodes, c, best, target);
		}
		return best;
	}

	return solve(nodes, 0, nodes[0].size, to_look);
}

main :: () -> (int, int) {
	input, success :: #run read_entire_file("Inputs/07.txt");
	if !success {
		print("Error reading input\n");
		return (-1, -1);
	}

	return part1(input), part2(input);
}