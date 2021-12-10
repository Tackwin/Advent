#import "Basic";
#import "File";
#import "String";

Game :: struct {
	order : [] int;

	boards : [][25] int;
}

part1 :: (game: Game) -> int {
	mask : [..][25] bool;
	array_resize(*mask, game.boards.count);

	is_winning :: (m: [25] bool) -> bool {
		for x: 0..4 if m[x + 0 * 5] && m[x + 1 * 5] && m[x + 2 * 5] && m[x + 3 * 5] && m[x + 4 * 5]
			return true;
		for y: 0..4 if m[0 + y * 5] && m[1 + y * 5] && m[2 + y * 5] && m[3 + y * 5] && m[4 + y * 5]
			return true;

		return false;
	};

	for game.order {
		for board, board_idx: game.boards for x, idx: board if x == it mask[board_idx][idx] = true;

		for m, m_idx: mask if is_winning(m) {

			sum := 0;

			for f: m if !f sum += game.boards[m_idx][it_index];

			return sum * it;
		}
	}


	return 0;
}

part2 :: (game: Game) -> int {
	mask : [..][25] bool;
	won : [..]bool;
	
	left_to_win := game.boards.count;

	array_resize(*mask, game.boards.count);
	array_resize(*won, game.boards.count);

	is_winning :: (m: [25] bool) -> bool {
		for x: 0..4 if m[x + 0 * 5] && m[x + 1 * 5] && m[x + 2 * 5] && m[x + 3 * 5] && m[x + 4 * 5]
			return true;
		for y: 0..4 if m[0 + y * 5] && m[1 + y * 5] && m[2 + y * 5] && m[3 + y * 5] && m[4 + y * 5]
			return true;

		return false;
	};

	for game.order {
		for board, board_idx: game.boards for x, idx: board if x == it mask[board_idx][idx] = true;

		for m, m_idx: mask if !won[m_idx] && is_winning(m) {
			won[m_idx] = true;
			left_to_win -= 1;
			if left_to_win == 0 {
				sum := 0;

				for f: m if !f sum += game.boards[m_idx][it_index];

				return sum * it;
			}
		}
	}

	return 0;
}

main :: () -> (int, int) {
	input, success := read_entire_file("Inputs/04.txt");
	if !success {
		print("Error reading input\n");
		return -1, -1;
	}

	lines := split(input, "\n");

	game : Game;

	order_strings := split(lines[0], ",");

	orders : [..]int;
	boards : [..][25] int;

	for order_strings {
		x, _, __ := to_integer(it);
		array_add(*orders, x);
	}


	n_boards := (lines.count - 1) / 6;

	n := 0;
	while n < n_boards {

		board_string : string;
		board_string.data = lines[2 + n * 6].data;
		board_string.count = 0;
		for 0..4 board_string.count += 1 + lines[it + 2 + n * 6].count;

		for 0..board_string.count-1 if board_string[it] == #char "\n" board_string[it] = #char " ";

		b : [25] int;
		x : int;
		success : bool;
		for b {
			x, success, board_string = to_integer(board_string);
			b[it_index] = x;
		}

		array_add(*boards, b);

		n += 1;
	}

	game.order = orders;
	game.boards = boards;

	return part1(game), part2(game);
}
