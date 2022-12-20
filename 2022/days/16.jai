
#scope_file
#import "Basic";
#import "File";
#import "Sort";
#import "String";
#import "Math";
#import "Hash_Table";

gen_dist_matrix :: (nodes: [] int, A: [] int, n_nodes: int) -> [] int {
	// Use unweighted BFS on every vertices to generate the distance matrix
	final_dist := NewArray(nodes.count * nodes.count, int);

	for src, src_idx: nodes {

		// BFS queue
		queue := NewArray(n_nodes, int);
		defer free(queue.data);

		// Visited array
		visited := NewArray(n_nodes, bool);
		defer free(visited.data);

		// distance matrix
		B := NewArray(n_nodes * n_nodes, int);
		defer free(B.data);

		// Initialize the queue
		queue.count = 1;
		queue[queue.count - 1] = src;
		
		// Initialize the visited array
		for 0..n_nodes-1 visited[it] = false;
		visited[src] = true;

		// Initialize the distance matrix
		for * B { <<it = 0; }

		// BFS
		cursor := 0;
		while cursor < queue.count {
			cur := queue[cursor];
			cursor += 1;

			for dst: 0..n_nodes-1 if dst != cur && A[cur + dst * n_nodes] != 0 && !visited[dst] {
				visited[dst] = true;
				queue.count += 1;
				queue[queue.count - 1] = dst;
				B[dst + src * n_nodes] = B[cur + src * n_nodes] + 1;
			}
		}

		for dst, dst_idx: nodes {
			final_dist[src_idx + dst_idx * nodes.count] = B[dst + src * n_nodes];
			final_dist[dst_idx + src_idx * nodes.count] = B[dst + src * n_nodes];
		}
	}
	return final_dist;
}


max_possible :: (nodes: [] int, n_nodes: int, time: int) -> int {
	m := 0;
	for 0..n_nodes-1 if nodes[it + it * n_nodes] > 0 m += nodes[it + it * n_nodes] * time;
	return m;
}

score :: (
	dist: [] int, src: int, rest: [] int, nodes: [] int, n_nodes: int, time: int, best: int
) -> int {
	if time <= 0 return 0;
	if rest.count == 0 return 0;

	bst := 0;
	for i: 0..rest.count-1 if rest[i] >= 0 && src != rest[i] {
		t := rest[i];
		rest[i] = -1;
		defer rest[i] = t;

		child_s := score(dist, t, rest, nodes, n_nodes, time - dist[src + t * n_nodes] - 1, bst);
		if child_s > bst bst = child_s;
	}

	return nodes[src + src * n_nodes] * (time - 1) + bst;
}

compute_score :: (
	p1: [] int, p2: [] int, AAdist: [] int, dist: [] nodes, nz: int, [] int, n_nodes: int
) -> int {
	time := 26;
	s := 0;

	if p1.count > 0 {
		time -= AAdist[p1[0] + p1[0] * n_nodes];
		s += (time - 1) * nodes[p1[0] + p1[0] * n_nodes];

		for 1..p1.count - 1 {
			time -= dist[p1[it] + p1[it - 1] * nz];
			s += (time - 1) * nodes[p1[it] + p1[it] * n_nodes];
		}
	}

	if p2.count > 0 {
		time -= AAdist[p2[0] + p2[0] * n_nodes];
		s += (time - 1) * nodes[p2[0] + p2[0] * n_nodes];

		for 1..p2.count - 1 {
			time -= dist[p2[it] + p2[it - 1] * nz];
			s += (time - 1) * nodes[p2[it] + p2[it] * n_nodes];
		}
	}

	return s;
}

score2 :: (
	path_you: *[] int,
	path_ele: *[] int,
	you: int,
	ele: int,
	nodes: [] int,
	n_nodes: int,
	time: int,
	best: int
) -> int {
	for outer: 0..0 {
		for 0..n_nodes - 1 if nodes[it + it * n_nodes] > 0 break outer;
		return 0;
	}
	if time <= 1 return 0;
	if max_possible(nodes, n_nodes, time - 1) <= best {
		return 0;
	}

	s := 0;
	if nodes[you + you * n_nodes] > 0 {
		t := nodes[you + you * n_nodes];
		nodes[you + you * n_nodes] = 0;
		defer nodes[you + you * n_nodes] = t;
		s += t * (time - 1);

		path_you.count += 1;
		path_you.data[path_you.count - 1] = you;
		defer path_you.count -= 1;

			bst := 0;
		if nodes[ele + ele * n_nodes] <= 0 {
			for 0..n_nodes - 1 if nodes[it + ele * n_nodes] > 0 && it != ele {
				bst = max(bst, score2(path_you, path_ele, you, it, nodes, n_nodes, time - 1, bst));
			}

			s += bst;

		} else {
			t := nodes[ele + ele * n_nodes];
			nodes[ele + ele * n_nodes] = 0;
			defer nodes[ele + ele * n_nodes] = t;
			s += t * (time - 1);

			path_ele.count += 1;
			path_ele.data[path_ele.count - 1] = ele;
			defer path_ele.count -= 1;

			bst = max(bst, score2(path_you, path_ele, you, ele, nodes, n_nodes, time - 1, bst));
		}
		// if (I % 10000) == 0 print("aPath % % %\n", s, <<path_you, <<path_ele);
	I += 1;
	} else {

		bst := 0;
		for 0..n_nodes - 1 if nodes[it + you * n_nodes] > 0 && it != you {
			if nodes[ele + ele * n_nodes] <= 0 {
				for jt: 0..n_nodes - 1 if nodes[jt + ele * n_nodes] > 0 && jt != ele {
					bst = max(bst, score2(path_you, path_ele, it, jt, nodes, n_nodes, time - 1, bst));
				}
				// if (I % 10000) == 0 print("bPath % % %\n", s, <<path_you, <<path_ele);
	I += 1;
			} else {
				t := nodes[ele + ele * n_nodes];
				nodes[ele + ele * n_nodes] = 0;
				defer nodes[ele + ele * n_nodes] = t;
				s := t * (time - 1);

				path_ele.count += 1;
				path_ele.data[path_ele.count - 1] = ele;
				defer path_ele.count -= 1;

				bst = max(
					bst, score2(path_you, path_ele, it, ele, nodes, n_nodes, time - 1, bst) + s
				);
			}
		}
		
		s += bst;
	}


	return s;
}

I := 0;

#scope_export
part1 :: (input: string) -> int {
	found: bool;
	line: string;
	rest := input;

	n_nodes := 0;
	for 0..input.count - 1 if input[it] == #char "\n" n_nodes += 1;

	table: Table(string, int);

	nodes := NewArray(n_nodes * n_nodes, int);
	defer free(nodes.data);

	while true {
		found, line, rest = split_from_left(rest, #char "\n");
		if !found break;

		ok1, left_string, right_string := split_from_left(line, #char ";");
		valve_string := slice(left_string, 6, 2);
		flow_rate_string := slice(left_string, 23, left_string.count);
		neighbors_string: string;
		if starts_with(right_string, " tunnel ") {
			neighbors_string = slice(right_string, 23, right_string.count);
		} else {
			neighbors_string = slice(right_string, 24, right_string.count);
		}
		neighbors_list := split(neighbors_string, ", ");

		flow_rate := 0;
		if !scan2(flow_rate_string, "%", *flow_rate) continue;

		valve, ok2 := table_find(*table, valve_string);
		if !ok2 {
			valve = table.count;
			table_add(*table, valve_string, valve);
		}

		nodes[valve + valve * n_nodes] = flow_rate;

		for neighbors_list {
			neighbor, ok3 := table_find(*table, it);
			if !ok3 {
				neighbor = table.count;
				table_add(*table, it, neighbor);
			}

			nodes[neighbor + valve * n_nodes] = 1;
			nodes[valve + neighbor * n_nodes] = 1;
		}
	}

	nz := 0;
	for 0..n_nodes-1 {
		if nodes[it + it * n_nodes] != 0 nz += 1;
	}

	AA, ok := table_find(*table, "AA");
	if !ok return -1;

	nonzeros := NewArray(nz + 1, int);
	nz = 0;
	for 0..n_nodes-1 if nodes[it + it * n_nodes] != 0 {
		nonzeros[nz] = it;
		nz += 1;
	}
	nonzeros.count = nz;

	nodes_list := NewArray(n_nodes, int);
	for * nodes_list { <<it = it_index; }

	dist_matrix := gen_dist_matrix(nodes_list, nodes, n_nodes);
	return score(dist_matrix, AA, nonzeros, nodes, n_nodes, 31, 0);
}

part2 :: (input: string) -> int {
	found: bool;
	line: string;
	rest := input;

	n_nodes := 0;
	for 0..input.count - 1 if input[it] == #char "\n" n_nodes += 1;

	table: Table(string, int);

	nodes := NewArray(n_nodes * n_nodes, int);
	defer free(nodes.data);

	while true {
		found, line, rest = split_from_left(rest, #char "\n");
		if !found break;

		ok1, left_string, right_string := split_from_left(line, #char ";");
		valve_string := slice(left_string, 6, 2);
		flow_rate_string := slice(left_string, 23, left_string.count);
		neighbors_string: string;
		if starts_with(right_string, " tunnel ") {
			neighbors_string = slice(right_string, 23, right_string.count);
		} else {
			neighbors_string = slice(right_string, 24, right_string.count);
		}
		neighbors_list := split(neighbors_string, ", ");

		flow_rate := 0;
		if !scan2(flow_rate_string, "%", *flow_rate) continue;

		valve, ok2 := table_find(*table, valve_string);
		if !ok2 {
			valve = table.count;
			table_add(*table, valve_string, valve);
		}

		nodes[valve + valve * n_nodes] = flow_rate;

		for neighbors_list {
			neighbor, ok3 := table_find(*table, it);
			if !ok3 {
				neighbor = table.count;
				table_add(*table, it, neighbor);
			}

			nodes[neighbor + valve * n_nodes] = 1;
			nodes[valve + neighbor * n_nodes] = 1;
		}
	}

	nz := 0;
	for 0..n_nodes-1 {
		if nodes[it + it * n_nodes] != 0 nz += 1;
	}

	AA, ok := table_find(*table, "AA");
	if !ok return -1;

	nonzeros := NewArray(nz + 1, int);
	nz = 0;
	for 0..n_nodes-1 if nodes[it + it * n_nodes] != 0 {
		nonzeros[nz] = it;
		nz += 1;
	}
	nonzeros.count = nz;

	nodes_list := NewArray(n_nodes, int);
	for * nodes_list { <<it = it_index; }

	dist_matrix := gen_dist_matrix(nodes_list, nodes, n_nodes);
	p1 := NewArray(n_nodes, int);
	p2 := NewArray(n_nodes, int);

	p1.count = 0;
	p2.count = 0;

	return score2(*p1, *p2, AA, AA, nodes, n_nodes, 16, 0);
}

main :: () -> (int, int) {
	input, success :: #run read_entire_file("Inputs/16.txt");
	if !success {
		print("Error reading input\n");
		return (-1, -1);
	}

	return part1(input), part2(input);
}