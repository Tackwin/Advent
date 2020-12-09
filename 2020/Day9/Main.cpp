#include <filesystem>
#include <fstream>
#include <vector>
#include <string>
#include <cstdlib>
#include <array>
#include <unordered_map>
#include <unordered_set>

using Entry = std::int64_t;

bool is_sum_of(Entry* entries, std::int64_t n) noexcept;
std::pair<size_t, size_t> find_range(const std::vector<Entry>& entries, std::int64_t n) noexcept;
std::vector<Entry> get_inputs(std::filesystem::path p) noexcept;

int main(int, char**) {
	auto entries = get_inputs("Day9/input");

	size_t i = 25;
	for (; i < entries.size() && is_sum_of(entries.data() + i - 25, entries[i]); ++i);

	auto num1 = entries[i];
	auto range = find_range(entries, num1);
	std::int64_t max_range = 0;
	std::int64_t min_range = INT64_MAX;
	for (size_t i = range.first; i <= range.second; ++i) {
		max_range = std::max(max_range, entries[i]);
		min_range = std::min(min_range, entries[i]);
	}

	auto num2 = max_range + min_range;

	printf("Part1: %lld\n", num1);
	printf("Part2: %lld\n", num2);

	return 0;
}

bool is_sum_of(Entry* entries, std::int64_t n) noexcept {
	for (size_t i = 0; i < 25; ++i) for (size_t j = i + 1; j < 25; ++j)
		if (entries[i] + entries[j] == n) return true;
	return false;
}

std::pair<size_t, size_t> find_range(const std::vector<Entry>& entries, std::int64_t n) noexcept {
	size_t start = 0;
	size_t end = 0;

	std::int64_t acc = 0;

	while (acc != n && start < entries.size() && end < entries.size()) {
		if (acc < n) {
			acc += entries[end];
			end++;
		}
		if (acc > n) {
			acc -= entries[start];
			start++;
		}
	}

	return { start, end - 1 };
}


std::vector<Entry> get_inputs(std::filesystem::path p) noexcept {
	std::fstream f;
	std::string l;

	f.open(p.generic_string());

	std::vector<Entry> entries;
	while(std::getline(f, l)) entries.push_back((size_t)std::stoull(l));
	return entries;
}