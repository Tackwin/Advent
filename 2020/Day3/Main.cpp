#include <filesystem>
#include <fstream>
#include <vector>
#include <string>
#include <cstdlib>


struct Line {
	static constexpr size_t Tree_Line = 31;
	bool trees[Tree_Line] = {};
};

std::vector<Line> get_inputs(std::filesystem::path p) noexcept;
size_t count_tree(const std::vector<Line>& trees, size_t dx, size_t dy) noexcept {
	size_t n = 0;
	for (size_t x = 0, y = 0; y < trees.size(); x += dx, y += dy) {
		if (trees[y].trees[x % Line::Tree_Line]) n++;
	}
	return n;
}

int main(int, char**) {

	auto trees = get_inputs("Day3/input");


	printf("Part1: %zu\n", count_tree(trees, 3, 1));

	size_t n_min = 1;
	n_min *= count_tree(trees, 1, 1);
	n_min *= count_tree(trees, 3, 1);
	n_min *= count_tree(trees, 5, 1);
	n_min *= count_tree(trees, 7, 1);
	n_min *= count_tree(trees, 1, 2);
	printf("Part2: %zu\n", n_min);

	return 0;
}



std::vector<Line> get_inputs(std::filesystem::path p) noexcept {
	std::fstream f;
	std::string l;
	std::vector<Line> lines;

	f.open(p.generic_string());

	while(std::getline(f, l)) {
		Line x;
		char t[Line::Tree_Line];
		std::sscanf(
			l.c_str(),
			"%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c%c",
			t + 0,
			t + 1,
			t + 2,
			t + 3,
			t + 4,
			t + 5,
			t + 6,
			t + 7,
			t + 8,
			t + 9,
			t + 10,
			t + 11,
			t + 12,
			t + 13,
			t + 14,
			t + 15,
			t + 16,
			t + 17,
			t + 18,
			t + 19,
			t + 20,
			t + 21,
			t + 22,
			t + 23,
			t + 24,
			t + 25,
			t + 26,
			t + 27,
			t + 28,
			t + 29,
			t + 30
		);

		for (size_t i = 0; i < Line::Tree_Line; ++i) x.trees[i] = (t[i] == '#');
		lines.push_back(x);
	}

	return lines;
}
