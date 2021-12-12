#import "Basic";
#import "File";
#import "String";
#import "Sort";
#import "Hash_Table";

only_up :: (s: string) -> bool {
	for 0..s.count-1 if s[it] >= #char "a" return false;
	return true;
}

part1 :: (connection_matrix: [] int, big_map: [] bool, size: int) -> int {

	visit :: (
		n: int, visited: [] bool, connection_matrix: [] int, big_map: [] bool, size: int
	) -> int{
		if n == 1 return 1;
		
		before := visited[n];
		defer visited[n] = before;
		visited[n] = true;

		s := 0;
		for 0..size-1 if connection_matrix[it + n * size] > 0 if big_map[it] || !visited[it] {
			s += visit(it, visited, connection_matrix, big_map, size);
		}

		return s;
	}

	visited : [..] bool;
	array_resize(*visited, size);
	for * visited { << it = false; };

	return visit(0, visited, connection_matrix, big_map, size);
}

part2 :: (connection_matrix: [] int, big_map: [] bool, size: int) -> int {
	visit :: (
		n: int, visited: [] int, connection_matrix: [] int, big_map: [] bool, size: int
	) -> int{
		if n == 1 return 1;
		
		visited[n] += 1;
		defer visited[n] -= 1;

		max_visited := 0;
		for visited if !big_map[it_index] && it > max_visited max_visited = it;

		s := 0;
		for 0..size-1 if connection_matrix[it + n * size] > 0
			if big_map[it] || visited[it] < 1 || (visited[it] < 2 && max_visited < 2 && it > 1)
				s += visit(it, visited, connection_matrix, big_map, size);

		return s;
	}

	visited : [..] int;
	array_resize(*visited, size);
	for * visited { << it = 0; };

	return visit(0, visited, connection_matrix, big_map, size);
}

main :: () -> (int, int) {
	input, success := read_entire_file("Inputs/12.txt");
	if !success {
		print("Error reading input\n");
		return -1, -1;
	}

	lines := split(input, "\n");

	label_table : Table(string, int);
	table_set(*label_table, "start", 0);
	table_set(*label_table, "end", 1);

	for lines if it.data {
		a, b := split(it, "-")[0], split(it, "-")[1];

		if !table_find_pointer(label_table, a) table_set(*label_table, a, label_table.count);
		if !table_find_pointer(label_table, b) table_set(*label_table, b, label_table.count);
	}

	connection_matrix : [..] int;
	big_map : [..] bool;

	array_resize(*connection_matrix, label_table.count * label_table.count);
	array_resize(*big_map, label_table.count);

	for lines if it.data {
		a, b := split(it, "-")[0], split(it, "-")[1];

		i, found_i := table_find(label_table, a);
		j, found_j := table_find(label_table, b);
		assert(found_i);

		connection_matrix[i + j * label_table.count] = 1;
		connection_matrix[j + i * label_table.count] = 1;

		if only_up(a) big_map[i] = true;
		if only_up(b) big_map[j] = true;
	}

	return
		part1(connection_matrix, big_map, label_table.count),
		part2(connection_matrix, big_map, label_table.count);
}