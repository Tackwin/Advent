#include <filesystem>
#include <fstream>
#include <vector>
#include <string>
#include <cstdlib>
#include <array>
#include <unordered_map>
#include <unordered_set>

struct Entry {
	size_t w = 0;
	size_t h = 0;

	std::vector<uint8_t> is_seats;
	std::vector<uint8_t> is_taken;

	uint8_t& taken(size_t i, size_t j) { return is_taken[i + j * w]; }
	uint8_t& seats(size_t i, size_t j) { return is_seats[i + j * w]; }
};

Entry get_inputs(std::filesystem::path p) noexcept;

bool step1(Entry& e) {
	bool changed = false;

	Entry n = e;

	for (size_t i = 0; i < e.w; i++) {
		for (size_t j = 0; j < e.h; j++) {

			size_t c = 0;
			for (int off_i = -1; off_i < 2; ++off_i)
			for (int off_j = -1; off_j < 2; ++off_j) if (!(off_j == 0 && off_i == 0))
				if (i + off_i >= 0 && i + off_i < e.w && j + off_j >= 0 && j + off_j < e.h)
					c += (e.seats(i + off_i, j + off_j) && e.taken(i + off_i, j + off_j)) ? 1 : 0;

			if (!e.taken(i, j) && c == 0) { n.taken(i, j) = true;  changed = true; }
			if ( e.taken(i, j) && c >= 4) { n.taken(i, j) = false; changed = true; }

		}
	}

	e = n;
	return changed;
}

bool step2(Entry& e) {
	bool changed = false;

	auto is_visible_from_towards = [&](size_t i, size_t j, int off_i, int off_j) -> bool {
		for (
			int ii = (int)i + off_i, jj = (int)j + off_j;
			0 <= ii && ii < e.w && 0 <= jj && jj < e.h;
			ii += off_i, jj += off_j
		)
			if (e.seats(ii, jj)) return e.taken(ii, jj);
		
		return false;
	};

	Entry n = e;
	for (size_t i = 0; i < e.w; i++) {
		for (size_t j = 0; j < e.h; j++) if (e.seats(i, j)) {

			size_t c = 0;
			for (int off_i = -1; off_i < 2; ++off_i)
			for (int off_j = -1; off_j < 2; ++off_j) if (!(off_j == 0 && off_i == 0))
				if (i + off_i >= 0 && i + off_i < e.w && j + off_j >= 0 && j + off_j < e.h)
					c += is_visible_from_towards(i, j, off_i, off_j) ? 1 : 0;

			if (!e.taken(i, j) && c == 0) { n.taken(i, j) = true;  changed = true; }
			if ( e.taken(i, j) && c >= 5) { n.taken(i, j) = false; changed = true; }

		}
	}

	e = n;
	return changed;
}

void print(Entry& e) noexcept {
	for (size_t i = 0; i < e.w; i++) {
		for (size_t j = 0; j < e.h; j++) {
			if      (!e.seats(i, j)) printf(".");
			else if ( e.taken(i, j)) printf("#");
			else if (!e.taken(i, j)) printf("L");
		}
		printf("\n");
	}
}

int main(int, char**) {
	size_t num1 = 0;
	size_t num2 = 0;

	auto entry = get_inputs("Day11/input");
	auto entry1 = entry;
	auto entry2 = entry;

	while (step1(entry1));
	for (size_t i = 0; i < entry1.w * entry1.h; ++i)
		num1 += (entry1.is_seats[i] && entry1.is_taken[i]) ? 1 : 0;


	while (step2(entry2));
	for (size_t i = 0; i < entry2.w * entry2.h; ++i)
		num2 += (entry2.is_seats[i] && entry2.is_taken[i]) ? 1 : 0;



	printf("Part1: %lld\n", num1);
	printf("Part1: %lld\n", num2);

	return 0;
}


Entry get_inputs(std::filesystem::path p) noexcept {
	std::fstream f;
	std::string l;

	f.open(p.generic_string());

	Entry entry;
	while(std::getline(f, l)) {
		entry.w = l.size();
		entry.h++;

		for (auto& c : l) entry.is_seats.push_back(c != '.');
		for (auto& c : l) entry.is_taken.push_back(c != 'L');
	}
	return entry;
}