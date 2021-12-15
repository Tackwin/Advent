#import "Basic";
#import "File";
#import "String";
#import "Sort";
#import "Hash_Table";
#import "Hash";

part1 :: (grid: [] int, w: int, h: int) -> int {

	dist := array_copy(grid);
	prev := array_copy(grid);

	for * dist{ <<it = 1 << 62; }
	for * prev{ <<it = -1; }

	dist[0] = 0;

	Q : [..] int;
	array_resize(*Q, w * h);
	for * Q{ <<it = it_index; };

	find_min :: (Q: [] int, dist: [] int) -> (int, int, int) {
		if Q.count == 0 return -1, -1, -1;
		
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

	find_node :: (Q: [] int, n: int) -> bool {
		for Q if it == n return true;
		return false;
	}

	while Q.count > 0 {
		d, a, q_idx := find_min(Q, dist);

		for q_idx..Q.count-2 Q[it] = Q[it+1];
		Q.count -= 1;

		a_x := a % w;
		a_y := a / h;

		v := (a_x - 1) + (a_y - 0) * w;
		alt := d + grid[v];
		if a_x > 0 && alt < dist[v] && find_node(Q, v) {
			dist[v] = alt;
			prev[v] = a;
		}
		v = (a_x + 1) + (a_y - 0) * w;
		alt = d + grid[v];
		if a_x + 1 < w && alt < dist[v] && find_node(Q, v) {
			dist[v] = alt;
			prev[v] = a;
		}
		v = (a_x + 0) + (a_y - 1) * w;
		alt = d + grid[v];
		if a_y > 0 && alt < dist[v] && find_node(Q, v) {
			dist[v] = alt;
			prev[v] = a;
		}
		v = (a_x + 0) + (a_y + 1) * w;
		alt = d + grid[v];
		if a_y + 1 < h && alt < dist[v] && find_node(Q, v) {
			dist[v] = alt;
			prev[v] = a;
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