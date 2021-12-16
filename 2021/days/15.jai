#import "Basic";
#import "File";
#import "String";
#import "Sort";
#import "Hash_Table";
#import "Hash";


resort :: (arr : [] int, m: [] int) {
	idx := 0;
	while idx < arr.count - 1 && m[arr[idx]] <= m[arr[idx + 1]] { idx += 1; }

	removed := arr[idx + 1];

	for idx+1..arr.count-2 arr[it] = arr[it + 1];

	new_idx := 0;
	while new_idx < arr.count - 2 && m[arr[new_idx]] <= m[removed] { new_idx += 1; }

	for < arr.count-1..new_idx+1 arr[it] = arr[it - 1];
	arr[new_idx] = removed;
}

quick_sort :: (array: [] int, dist: [] int) {
	// @Cleanup: This is a cutnpaste from the Quicksort above, except
	// with a different type of f. If we could do some kind of fancy
	// thing with static_if, we would not have to copy and paste the code.

	quicksort_helper :: (a: *int, n: s64, dist: [] int) {
		if n < 2 return;

		p := a[n / 2];

		i := 0;
		j := n-1;

		while true {
			fp := dist[p];
			while dist[a[i]] < fp  {i += 1;}
			while fp < dist[a[j]]  {j -= 1;}

			if i >= j break;

			t := a[i];
			a[i] = a[j];
			a[j] = t;

			i += 1;
			j -= 1;
		}
		
		quicksort_helper(a, i, dist);
		quicksort_helper(a + i, n - i, dist);
	}

	quicksort_helper(array.data, array.count, dist);
}

part1 :: (grid: [] int, w: int, h: int) -> int {

	dist := array_copy(grid);
	prev := array_copy(grid);
	visited := array_copy(grid);

	for * dist{ <<it = 1 << 62; }
	for * prev{ <<it = -1; }
	for * visited{ <<it = 0; }

	dist[0] = 0;

	Q : [..] int;
	array_resize(*Q, w * h);
	for * Q{ <<it = it_index; };

	find_min :: (Q: [] int, dist: [] int) -> (int, int, int) {
		m := dist[Q[0]];
		m_idx := 0;

		for Q {
			curr_m := dist[it];
			curr_idx := it_index;
			
			if curr_m < m {
				m = curr_m;
				m_idx = curr_idx;
			}
		}

		return m, Q[m_idx], m_idx;
	}

	while Q.count > 0 {
		d, a, q_idx := find_min(Q, dist);

		Q[q_idx] = Q[Q.count-1];
		Q.count -= 1;
		visited[a] = 1;

		a_x := a % w;
		a_y := a / h;

		if a_x > 0 {
			v := (a_x - 1) + (a_y - 0) * w;
			alt := d + grid[v];
			if alt < dist[v] && visited[v] <= 0 {
				dist[v] = alt;
				prev[v] = a;
				// resort(Q, dist);
			}
		}
		if a_x + 1 < w {
			v := (a_x + 1) + (a_y - 0) * w;
			alt := d + grid[v];
			if alt < dist[v] && visited[v] <= 0 {
				dist[v] = alt;
				prev[v] = a;
				// resort(Q, dist);
			}
		}
		if a_y > 0 {
			v := (a_x + 0) + (a_y - 1) * w;
			alt := d + grid[v];
			if alt < dist[v] && visited[v] <= 0 {
				dist[v] = alt;
				prev[v] = a;
				// resort(Q, dist);
			}
		}
		if a_y + 1 < h {
			v := (a_x + 0) + (a_y + 1) * w;
			alt := d + grid[v];
			if a_y + 1 < h && alt < dist[v] && visited[v] <= 0 {
				dist[v] = alt;
				prev[v] = a;
				// resort(Q, dist);
			}
		}
	}

	return dist[dist.count - 1];
}

part2 :: (grid: [] int, w: int, h: int) -> int {

	full_grid : [..] int;
	array_resize(*full_grid, w * h * 25);

	full_w := 5 * w;
	full_h := 5 * h;

	for y: 0..h-1 {
		for x: 0..w-1 {
			it := grid[x + y * w];

			for X: 0..4 {
				for Y: 0..4 {
					p := X + Y;

					full_grid[x + w * X + (y + h * Y) * full_w] = 1 + (it + p - 1) % 9;
				}
			}
		}
	}

	return part1(full_grid, full_w, full_h);
}

main :: () -> (int, int) {
	input, success := read_entire_file("Inputs/15.txt");
	if !success {
		print("Error reading input\n");
		return -1, -1;
	}

	lines := split(input, "\n");

	grid : [..] int;
	w := 0;
	h := 0;

	for lines if it.data {
		for c: 0..it.count-1 array_add(*grid, it[c] - #char "0");

		w = it.count;
		h += 1;
	}

	return part1(grid, w, h), part2(grid, w, h);
}