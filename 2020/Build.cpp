#include "Ease.hpp"

/*
clang++ Build.cpp -o Build.exe -std=c++17
*/
Build day1(Flags flags) noexcept;
Build day2(Flags flags) noexcept;
Build day3(Flags flags) noexcept;
Build day4(Flags flags) noexcept;
Build day5(Flags flags) noexcept;

Build build(Flags flags) noexcept {
	auto start = day1(flags);
	auto* curr = &start;

	curr->next = day2(flags);
	curr = curr->next.b;
	
	curr->next = day3(flags);
	curr = curr->next.b;

	curr->next = day4(flags);
	curr = curr->next.b;

	curr->next = day5(flags);
	curr = curr->next.b;
	
	return start;
}

Build day1(Flags flags) noexcept {
	if (!flags.output) flags.output = "Day1/";

	auto b = Build::get_default(flags);

	b.name = "Day1";

	b.add_source("Day1/Main.cpp");
	
	return b;
}

Build day2(Flags flags) noexcept {
	if (!flags.output) flags.output = "Day2/";

	auto b = Build::get_default(flags);

	b.name = "Day2";

	b.add_source("Day2/Main.cpp");
	
	return b;
}
Build day3(Flags flags) noexcept {
	if (!flags.output) flags.output = "Day3/";

	auto b = Build::get_default(flags);

	b.name = "Day3";

	b.add_source("Day3/Main.cpp");
	
	return b;
}
Build day4(Flags flags) noexcept {
	if (!flags.output) flags.output = "Day4/";

	auto b = Build::get_default(flags);

	b.name = "Day4";

	b.add_source("Day4/Main.cpp");
	
	return b;
}


Build day5(Flags flags) noexcept {
	if (!flags.output) flags.output = "Day5/";

	auto b = Build::get_default(flags);

	b.name = "Day5";

	b.add_source("Day5/Main.cpp");
	
	return b;
}

