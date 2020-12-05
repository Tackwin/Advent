#include "Ease.hpp"

/*
clang++ Build.cpp -o Build.exe -std=c++17
*/

#define X(n)\
Build day##n(Flags flags) {\
	if (!flags.output) flags.output = "Day"#n"/";\
	auto b = Build::get_default(flags);\
	b.name = "Day"#n;\
	b.add_source("Day"#n"/Main.cpp");\
	b.add_define("_CRT_SECURE_NO_WARNINGS");\
	return b;\
}
X(1) X(2) X(3) X(4) X(5)
#undef X


Build build(Flags flags) noexcept {

	auto f = std::vector<Build(*)(Flags)>{ day1, day2, day3, day4, day5 };
	Build curr = f.back()(flags);

	for (size_t i = f.size() - 2; i + 1 > 0; --i) {
		auto& x = f[i];

		auto n = x(flags);
		n.next = curr;
		curr = n;
	}

	return curr;
}
