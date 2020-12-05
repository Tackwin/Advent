#include <string>
#include <vector>
#include <fstream>
#include <iostream>
#include <optional>
#include <filesystem>

std::vector<size_t> read_input(std::filesystem::path p) noexcept;

int main(int, char**) {

	auto v = read_input("Day1/input");

	printf("Part1: ");
	for (size_t i = 0 + 0; i < v.size(); ++i)
	for (size_t j = i + 1; j < v.size(); ++j) {
		if (v[i] + v[j] == 2020) {
			printf("%zu\n", v[i] * v[j]);
			break;
		}
	}


	printf("Part2: ");
	for (size_t i = 0 + 0; i < v.size(); ++i)
	for (size_t j = i + 1; j < v.size(); ++j) {
	for (size_t k = j + 1; k < v.size(); ++k)
		if (v[i] + v[j] + v[k] == 2020) {
			printf("%zu\n", v[i] * v[j] * v[k]);
			break;
		}
	}

	return 0;
}

std::vector<size_t> read_input(std::filesystem::path p) noexcept {
	std::ifstream f;
	std::string l;
	std::vector<size_t> r;

	f.open(p.generic_string());

	while (std::getline(f, l)) r.push_back(std::stoull(l));

	return r;
}