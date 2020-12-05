#include <filesystem>
#include <fstream>
#include <vector>
#include <string>
#include <cstdlib>

struct In {
	size_t low = 0;
	size_t high = 0;
	char c = 'a';
	std::string pass;
};

std::vector<In> get_inputs(std::filesystem::path p) noexcept;

int main(int, char**) {
	auto in = get_inputs("Day2/input");

	size_t count1 = 0;
	size_t count2 = 0;

	for (auto& x : in) if (
		auto n = std::count(std::begin(x.pass), std::end(x.pass), x.c); x.low <= n && n <= x.high
	) count1++;
	for (auto& x : in) if ((x.pass[x.low - 1] == x.c) ^ (x.pass[x.high - 1] == x.c)) count2++;

	printf("Part1: %zu\n", count1);
	printf("Part2: %zu\n", count2);
	return 0;
}

std::vector<In> get_inputs(std::filesystem::path p) noexcept {
	std::fstream f;
	std::string l;
	std::vector<In> ins;

	f.open(p.generic_string());

	while(std::getline(f, l)) {
		In x;
		x.pass.resize(100, '\0');
		std::sscanf(l.c_str(), "%zu-%zu %c: %s", &x.low, &x.high, &x.c, x.pass.data());
		ins.push_back(x);
	}

	return ins;
}
