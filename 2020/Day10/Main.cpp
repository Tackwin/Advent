#include <filesystem>
#include <fstream>
#include <vector>
#include <string>
#include <cstdlib>
#include <array>
#include <unordered_map>
#include <unordered_set>

using Entry = std::int64_t;

std::vector<Entry> get_inputs(std::filesystem::path p) noexcept;

size_t num_paths(Entry* entries, size_t size) noexcept {
	if (size < 2) return 1;
	thread_local std::unordered_map<size_t, size_t> cache;

	if (cache.count(size)) return cache.at(size);

	size_t n = 0;
	if (size > 1 && entries[0] + 3 >= entries[1]) n += num_paths(entries + 1, size - 1);
	if (size > 2 && entries[0] + 3 >= entries[2]) n += num_paths(entries + 2, size - 2);
	if (size > 3 && entries[0] + 3 >= entries[3]) n += num_paths(entries + 3, size - 3);

	cache[size] = n;
	return n;
}

int main(int, char**) {
	auto entries = get_inputs("Day10/input");

	std::sort(std::begin(entries), std::end(entries));

	size_t num1 = 0;
	size_t num2 = 0;

	size_t n_1 = 1;
	size_t n_3 = 1;
	for (size_t i = 1; i < entries.size(); ++i) if (entries[i] - entries[i - 1] == 1) n_1++;
	for (size_t i = 1; i < entries.size(); ++i) if (entries[i] - entries[i - 1] == 3) n_3++;

	num1 = n_1 * n_3;
	num2 = num_paths(entries.data(), entries.size());
	num2 += entries[1] < 4 ? num_paths(entries.data() + 1, entries.size() - 1) : 0;
	num2 += entries[2] < 4 ? num_paths(entries.data() + 2, entries.size() - 2) : 0;

	printf("Part1: %lld\n", num1);
	printf("Part1: %lld\n", num2);

	return 0;
}


std::vector<Entry> get_inputs(std::filesystem::path p) noexcept {
	std::fstream f;
	std::string l;

	f.open(p.generic_string());

	std::vector<Entry> entries;
	while(std::getline(f, l)) entries.push_back((size_t)std::stoull(l));
	return entries;
}