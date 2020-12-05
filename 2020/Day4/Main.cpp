#include <filesystem>
#include <fstream>
#include <vector>
#include <string>
#include <cstdlib>

struct Line {
	enum Fields {
		byr = 0,
		iyr,
		eyr,
		hgt,
		hcl,
		ecl,
		pid,
		cid,
		Count
	};

	std::string fields[Fields::Count];
	bool fields_present[Fields::Count] = { 0 };
};

std::vector<Line> get_inputs(std::filesystem::path p) noexcept;

int main(int, char**) {

	auto inputs = get_inputs("Day4/input");

	size_t n_valid1 = 0;
	for (auto& x : inputs) {
		bool not_valid = false;
		for (size_t i = 0; i < Line::Count; ++i) if (i != Line::cid && !x.fields_present[i]) {
			not_valid = true;
			break;
		} else if (i != Line::cid) {
			auto& it = x.fields[i];

			switch ((Line::Fields)i) {
			case Line::byr:
				not_valid |= !(1920 <= std::stoi(it) && std::stoi(it) <= 2002);
				break;
			case Line::iyr:
				not_valid |= !(2010 <= std::stoi(it) && std::stoi(it) <= 2020);
				break;
			case Line::eyr:
				not_valid |= !(2020 <= std::stoi(it) && std::stoi(it) <= 2030);
				break;
			case Line::hgt:
				not_valid |= it.size() <= 2 ||
					!(memcmp(it.data() + it.size() - 2, "in", 2) == 0 ||
					memcmp(it.data() + it.size() - 2, "cm", 2) == 0);
				if (!not_valid) {
					bool cm = it.back() == 'm';
					std::string n = it.substr(0, it.size() - 2);
					not_valid |= cm && !(150 <= std::stoi(n) && std::stoi(n) <= 193);
					not_valid |= !cm && !(59 <= std::stoi(n) && std::stoi(n) <= 76);
				}
				break;
			case Line::hcl:
				not_valid |= it.size() != 7;
				not_valid |= it[0] != '#';
				for (size_t j = 1; j < 7; ++j)
					not_valid |=
						!(('a' <= it[j] && it[j] <= 'f') || ('0' <= it[j] && it[j] <= '9'));
				break;
			case Line::ecl:
				not_valid |= !(
					it.find("amb") == 0 ||
					it.find("blu") == 0 ||
					it.find("brn") == 0 ||
					it.find("gry") == 0 ||
					it.find("grn") == 0 ||
					it.find("hzl") == 0 ||
					it.find("oth") == 0
				);
				break;
			case Line::pid:
				not_valid |= it.size() != 9;
				not_valid |= std::count_if(
					std::begin(it), std::end(it), [](char c) { return std::isdigit(c); }
				) != 9;
				break;
			default:
				break;
			}

			if (not_valid) break;
		}



		if (!not_valid) n_valid1++;
	}


	printf("Part1: %zu\n", n_valid1);

	return 0;
}



std::vector<Line> get_inputs(std::filesystem::path p) noexcept {
	std::vector<Line> lines;
	std::string file;

	FILE * f = fopen(p.generic_string().c_str(), "rb");
	fseek (f, 0, SEEK_END);
	auto length = ftell (f);
	fseek (f, 0, SEEK_SET);
	file.resize(length + 1);
	fread(file.data(), 1, length, f);
	fclose (f);


	
	std::vector<std::string> passport_strings;

	size_t cursor = 0;
	size_t last = 0;
	while ((cursor = file.find("\n\n", last)) != std::string::npos) {
		passport_strings.push_back(file.substr(last, cursor - last));
		last = cursor + 2;
	}
	if (last < file.size()) passport_strings.push_back(file.substr(last, file.size() - last));

	std::vector<std::string> tokens;
	for (auto& x : passport_strings) {
		tokens.clear();
		cursor = 0;
		last = 0;

		while ((cursor = x.find_first_of(" ""\n", last)) != std::string::npos) {
			tokens.push_back(x.substr(last, cursor - last));
			last = cursor + 1;
		}
		if (last < x.size()) tokens.push_back(x.substr(last, x.size() - last));

		Line l;

		for (auto& y : tokens) {
			#define X(V) if (memcmp(y.data(), #V, 3) == 0) {\
				l.fields[Line::V] = y.data() + 4;\
				l.fields_present[Line::V] = true;\
			}

			X(byr); X(iyr); X(eyr); X(hgt); X(hcl); X(ecl); X(pid); X(cid);

			#undef X
		}

		lines.push_back(l);
	}


	return lines;
}
