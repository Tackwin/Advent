#include <filesystem>
#include <fstream>
#include <vector>
#include <string>
#include <cstdlib>
#include <array>


using Entry = std::array<std::vector<bool>, 26>;

std::vector<Entry> get_inputs1(std::filesystem::path p) noexcept;
std::vector<Entry> get_inputs2(std::filesystem::path p) noexcept;

int main(int, char**) {

	auto entries = get_inputs1("Day6/input");

	#define B(x) std::begin(x)
	#define E(x) std::end(x)

	size_t sum1 = 0;
	size_t sum2 = 0;
	for (auto& e : entries) for (auto& x : e) if (std::count(B(x), E(x), true ) >  0) sum1++;
	for (auto& e : entries) for (auto& x : e) if (std::count(B(x), E(x), false) == 0) sum2++;

	printf("Part1: %zu\n", sum1);
	printf("Part2: %zu\n", sum2);

	return 0;
}



std::vector<Entry> get_inputs1(std::filesystem::path p) noexcept {
	std::fstream f;
	std::string l;
	std::vector<Entry> entries;

	f.open(p.generic_string());

	Entry x;
	while(std::getline(f, l)) {
		if (l.empty()) {
			entries.push_back(x);
			x = {};
			continue;
		}

		for (auto& a : x) a.push_back(false);
		for (auto& c : l) x[c - 'a'].back() = true;
	}
	entries.push_back(x);

	return entries;
}