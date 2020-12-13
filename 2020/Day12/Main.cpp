#include <filesystem>
#include <fstream>
#include <vector>
#include <string>
#include <cstdlib>
#include <array>
#include <unordered_map>
#include <unordered_set>

struct V2 {
	int x = 0;
	int y = 0;
};

struct Entry {
	enum Action {
		N,
		S,
		E,
		W,
		L,
		R,
		F
	} act;
	size_t arg;
};

std::vector<Entry> get_inputs(std::filesystem::path p) noexcept;

V2 end_pos1(const std::vector<Entry>& entries) noexcept {
	V2 p;

	Entry::Action dir = Entry::E;

	auto off_x = [](Entry::Action e) { return (e == Entry::E ? 1 : (e == Entry::W ? -1 : 0)); };
	auto off_y = [](Entry::Action e) { return (e == Entry::N ? 1 : (e == Entry::S ? -1 : 0)); };

	for (auto& x : entries) {
		if (x.act == x.F) {
			p.x += x.arg * off_x(dir);
			p.y += x.arg * off_y(dir);
		}
		else if (x.act == x.R) {
			for (size_t i = 0; i < x.arg; i += 90) {
				     if (dir == x.E) dir = x.S;
				else if (dir == x.S) dir = x.W;
				else if (dir == x.W) dir = x.N;
				else if (dir == x.N) dir = x.E;
			}
		}
		else if (x.act == x.L) {
			for (size_t i = 0; i < x.arg; i += 90) {
				     if (dir == x.E) dir = x.N;
				else if (dir == x.N) dir = x.W;
				else if (dir == x.W) dir = x.S;
				else if (dir == x.S) dir = x.E;
			}
		}
		else {
			p.x += x.arg * off_x(x.act);
			p.y += x.arg * off_y(x.act);
		}
	}

	return p;
}

V2 end_pos2(const std::vector<Entry>& entries) noexcept {
	V2 p;
	V2 waypoint = {10, 1};

	Entry::Action dir = Entry::E;

	auto off_x = [](Entry::Action e) { return (e == Entry::E ? 1 : (e == Entry::W ? -1 : 0)); };
	auto off_y = [](Entry::Action e) { return (e == Entry::N ? 1 : (e == Entry::S ? -1 : 0)); };

	for (auto& x : entries) {
		if (x.act == x.F) {
			p.x += x.arg * waypoint.x;
			p.y += x.arg * waypoint.y;
		}
		else if (x.act == x.R) {
			for (size_t i = 0; i < x.arg; i += 90) {
				auto t = waypoint.x;
				waypoint.x = waypoint.y;
				waypoint.y = -t;
			}
		}
		else if (x.act == x.L) {
			for (size_t i = 0; i < x.arg; i += 90) {
				auto t = waypoint.x;
				waypoint.x = -waypoint.y;
				waypoint.y = t;
			}
		}
		else {
			waypoint.x += x.arg * off_x(x.act);
			waypoint.y += x.arg * off_y(x.act);
		}
	}

	return p;
}


int main(int, char**) {
	size_t num1 = 0;
	size_t num2 = 0;

	auto entry = get_inputs("Day12/input");
	auto p1 = end_pos1(entry);
	auto p2 = end_pos2(entry);

	num1 = std::abs(p1.x) + std::abs(p1.y);
	num2 = std::abs(p2.x) + std::abs(p2.y);

	printf("Part1: %lld\n", num1);
	printf("Part1: %lld\n", num2);

	return 0;
}


std::vector<Entry> get_inputs(std::filesystem::path p) noexcept {
	std::fstream f;
	std::string l;

	f.open(p.generic_string());

	std::vector<Entry> entries;
	while(std::getline(f, l)) {
		Entry entry;

		char c = l[0];
		if (c == 'N') {
			entry.act = Entry::N;
		}
		if (c == 'S') {
			entry.act = Entry::S;
		}
		if (c == 'E') {
			entry.act = Entry::E;
		}
		if (c == 'W') {
			entry.act = Entry::W;
		}
		if (c == 'L') {
			entry.act = Entry::L;
		}
		if (c == 'R') {
			entry.act = Entry::R;
		}
		if (c == 'F') {
			entry.act = Entry::F;
		}

		entry.arg = std::stoi(l.data() + 1);

		entries.push_back(entry);
	}
	return entries;
}