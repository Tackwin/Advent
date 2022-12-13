#scope_file
#import "Basic";
#import "File";
#import "Sort";
#import "String";

Tree :: struct {
	parent: *Tree = null;
	childs: [..] *Tree;
	value: int = -1;
}

print :: (tree: Tree) {
	if tree.value != -1 {
		print("%", tree.value);
		return;
	}
	print("[");
	for tree.childs {
		print(<<it);
		if it_index != tree.childs.count - 1 {
			print(",");
		}
	}
	print("]");
}

read_tree :: (line: string) -> *Tree, string {
	resulti, ok, rest := to_integer(line);
	if ok {
		new := New(Tree);
		new.value = resulti;
		return new, rest;
	}

	result: *Tree;

	new := New(Tree);
	if rest[0] == #char "[" {
		rest.count -= 1;
		rest.data += 1;

		while rest[0] != #char "]" {
			result, rest = read_tree(rest);
			result.parent = new;
			array_add(*new.childs, result);

			if rest[0] == #char "," {
				rest.count -= 1;
				rest.data += 1;
			}
		}
		rest.count -= 1;
		rest.data += 1;
		return new, rest;
	}

	print("Line error: %\n", line);
	assert(false);
	return null, "";
}

compare :: (a: Tree, b: Tree) -> int {
	if a.value != -1 && b.value != -1 {
		if a.value < b.value return -1;
		if a.value > b.value return 1;
		return 0;
	}

	if a.value < 0 && b.value < 0 {
		for 0..min(a.childs.count, b.childs.count) - 1 {
			c := compare(<<a.childs[it], <<b.childs[it]);
			if c != 0 return c;
		}

		if a.childs.count < b.childs.count return -1;
		if a.childs.count > b.childs.count return +1;
		return 0;
	}

	if a.value >= 0 {
		arr: Tree;
		array_add(*arr.childs, *a);
		c := compare(arr, b);
		return c;
	}

	if b.value >= 0 {
		arr: Tree;
		array_add(*arr.childs, *b);
		c := compare(a, arr);
		return c;
	}

	return 0;
}

#scope_export
part1 :: (input: string) -> int {
	found: bool;
	line: string;
	rest := input;

	trees: [..] Tree;

	while true {
		found, line, rest = split_from_left(rest, #char "\n");
		if !found break;
		if line.count == 0 continue;
		
		tree, _ := read_tree(line);
		array_add(*trees, tree);
	}

	n := 0;
	for 0..trees.count / 2 -1 {
		if compare(trees[2 * it + 0], trees[2 * it + 1]) < 0 n += it + 1;
	}

	return n;
}

part2 :: (input: string) -> int {
	found: bool;
	line: string;
	rest := input;

	trees: [..] Tree;

	while true {
		found, line, rest = split_from_left(rest, #char "\n");
		if !found break;
		if line.count == 0 continue;
		
		tree, _ := read_tree(line);
		array_add(*trees, tree);
	}

	divider2: Tree;
	devider2_child: Tree;
	devider2_child_child: Tree;
	devider2_child_child.value = 2;
	array_add(*devider2_child.childs, *devider2_child_child);
	array_add(*divider2.childs, *devider2_child);

	divider6: Tree;
	devider6_child: Tree;
	devider6_child_child: Tree;
	devider6_child_child.value = 6;
	array_add(*devider6_child.childs, *devider6_child_child);
	array_add(*divider6.childs, *devider6_child);

	array_add(*trees, divider2);
	array_add(*trees, divider6);

	sorted := quick_sort(trees, compare);

	idx2 := 0;
	idx6 := 0;
	for sorted if compare(it, divider2) == 0 {
		idx2 = it_index + 1;
		break;
	}
	for sorted if compare(it, divider6) == 0 {
		idx6 = it_index + 1;
		break;
	}

	return idx2 * idx6;
}

main :: () -> (int, int) {
	input, success :: #run read_entire_file("Inputs/13.txt");
	if !success {
		print("Error reading input\n");
		return (-1, -1);
	}

	return part1(input), part2(input);
}