#include <filesystem>
#include <fstream>
#include <vector>
#include <string>
#include <cstdlib>

struct Line {
	size_t row;
	size_t col;
};

std::vector<Line> get_inputs(std::filesystem::path p) noexcept;
size_t id(Line l) { return l.col + l.row * 8; }

int main(int, char**) {
	auto inputs = get_inputs("Day5/input");
	size_t max = 0;
	size_t i = 1;

	for (auto& x : inputs) max = std::max(max, id(x));

	std::sort(std::begin(inputs), std::end(inputs), [](Line a, Line b) { return id(a) < id(b); });

	for (; i < inputs.size(); ++i) if (id(inputs[i - 1]) + 2 == id(inputs[i])) break;

	printf("Part1: %zu\n", max);
	printf("Part2: %zu\n", id(inputs[i]) - 1);

	return 0;
}

std::vector<Line> get_inputs(std::filesystem::path p) noexcept {
	std::vector<Line> lines;
	std::fstream f;
	std::string l;
	std::string r;
	std::string c;

	f.open(p.generic_string());

	while(std::getline(f, l)) {
		Line x;

		r.clear();
		c.clear();
		for (auto& c : l) if (c == 'B') r.push_back('1'); else r.push_back('0');
		for (auto& a : l) if (a == 'R') c.push_back('1'); else c.push_back('0');

		x.row = std::stoi(r.substr(0, 7), nullptr, 2);
		x.col = std::stoi(c.substr(7, 3), nullptr, 2);

		lines.push_back(x);
	}

	return lines;
}
