#include <filesystem>
#include <fstream>
#include <vector>
#include <string>
#include <cstdlib>
#include <array>
#include <unordered_map>
#include <unordered_set>

using Entry = std::unordered_map<std::string, std::vector<std::pair<size_t, std::string>>>;

bool can_hold(const Entry& e, std::string bag, std::string to_hold) noexcept {

	std::vector<std::string> open;
	std::unordered_set<std::string> close;

	open.push_back(bag);

	while(open.size() > 0) {
		auto x = open.back();
		open.pop_back();

		if (close.count(x) != 0) continue;
		if (e.count(x) == 0) continue;

		for (auto& [n, s] : e.at(x)) if (s == to_hold) return true; else open.push_back(s);
	}

	return false;
}

size_t count_bags(const Entry& e, std::string bag, size_t rec = 0) noexcept {
	if (e.count(bag) == 0) return 0;

	size_t sum = 0;
	for (auto& [n, s] : e.at(bag)) sum += n * (1 + count_bags(e, s, rec + 1));
	return sum;
}

std::vector<std::string> split(const std::string& str, const std::string& delim) {
	std::vector<std::string> tokens;
	size_t prev = 0;
	size_t pos = 0;
	do {
		pos = str.find(delim, prev);
		if (pos == std::string::npos) pos = str.length();

		std::string token = str.substr(prev, pos-prev);

		if (!token.empty()) tokens.push_back(token);

		prev = pos + delim.length();
	} while (pos < str.length() && prev < str.length());

	return tokens;
}

Entry get_inputs(std::filesystem::path p) noexcept;

int main(int, char**) {

	auto entry = get_inputs("Day7/input");

	size_t n1 = 0;
	size_t n2 = 0;
	for (auto& [k, v] : entry) if (can_hold(entry, k, " shiny gold ")) n1++;
	n2 = count_bags(entry, " shiny gold ");

	printf("Part1: %zu\n", n1);
	printf("Part2: %zu\n", n2);

	return 0;
}

Entry get_inputs(std::filesystem::path p) noexcept {
	std::fstream f;
	std::string l;

	f.open(p.generic_string());

	Entry x;
	while(std::getline(f, l)) {
		std::string bag;
		std::string rest;

		auto tokens = split(l, " bags contain ");
		if (tokens[1] == "no other bags.") continue;

		bag = " " + tokens[0] + " ";
		rest = tokens[1];
		rest.pop_back(); // removing the ending dot.

		auto list_of_bags = split(rest, ", ");

		std::vector<std::pair<size_t, std::string>> n_bags;
		
		for (size_t i = 0; i < list_of_bags.size(); ++i) {
			auto& b = list_of_bags[i];
			size_t n = 0;

			size_t to_trim_back = 4;
			size_t to_trim_front = 1;
			if (b.back() == 'g') to_trim_back--;

			n = b.front() - '0';
			b = b.substr(1, b.size() - to_trim_back - to_trim_front);

			x[bag].push_back({n, b});
		}
	}
	return x;
}