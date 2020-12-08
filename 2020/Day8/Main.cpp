#include <filesystem>
#include <fstream>
#include <vector>
#include <string>
#include <cstdlib>
#include <array>
#include <unordered_map>
#include <unordered_set>

struct Entry {
	enum { acc, jmp, nop } op;
	int arg;
};

std::vector<Entry> get_inputs(std::filesystem::path p) noexcept;
bool run(const std::vector<Entry>& prog, int& acc) noexcept;

int main(int, char**) {
	int acc1 = 0;
	int acc2 = 0;
	auto entries = get_inputs("Day8/input");

	run(entries, acc1);

	for (auto& x : entries) if (x.op != x.acc) {
		x.op = x.op == x.jmp ? x.nop : x.jmp;
		if (run(entries, acc2 = 0)) break;
		x.op = x.op == x.jmp ? x.nop : x.jmp;
	}

	printf("Part1: %d\n", acc1);
	printf("Part2: %d\n", acc2);

	return 0;
}

bool run(const std::vector<Entry>& prog, int& acc) noexcept {
	thread_local std::vector<bool> executed;
	executed.clear();
	executed.resize(prog.size());

	size_t idx = 0;
	for (; idx < prog.size();) {
		auto& it = prog[idx];

		if (executed[idx]) return false;
		executed[idx] = true;

		if (it.op == it.acc) { acc += it.arg; idx++; };
		if (it.op == it.jmp) idx += it.arg;
		if (it.op == it.nop) idx++;
	}

	return true;
}

std::vector<Entry> get_inputs(std::filesystem::path p) noexcept {
	std::fstream f;
	std::string l;

	f.open(p.generic_string());

	std::vector<Entry> entries;
	while(std::getline(f, l)) {
		Entry x;

		if (memcmp(l.data(), "acc", 3) == 0) x.op = x.acc;
		if (memcmp(l.data(), "jmp", 3) == 0) x.op = x.jmp;
		if (memcmp(l.data(), "nop", 3) == 0) x.op = x.nop;

		x.arg = std::stoi(l.data() + 4);

		entries.push_back(x);
	}
	return entries;
}