DAYS :: #run file_list(sprint("%1%2", #filepath, "days"));

get_imports :: () -> string {
	builder: String_Builder;
	defer free_buffers(*builder);
	for DAYS {
		path := parse_path(it);
		last := path.words[path.words.count-1];
		last.count -= 4;

		append(*builder, tprint("Day_%1 :: #import \"./days/%1\";\n", last));
	}
	return builder_to_string(*builder);
}
#insert #run get_imports();

main :: () {
	get_run :: () -> string {
		builder: String_Builder;
		defer free_buffers(*builder);

		runs : [..] string;
		for DAYS {
			path := parse_path(it);
			last := path.words[path.words.count-1];
			last.count -= 4;

			format :: #string XX
// %1

if (run_day < 0 || run_day == %1) {
	new_context := context;
	new_context.allocator = __temporary_allocator;
	push_context new_context {
		print("Day%%", "%1");
		t := get_time();
		int_f :: #type () -> (int, int);
		#if type_of(Day_%1.main) == int_f {
			a, b := Day_%1.main();
			r1 := tprint("%%", formatInt(a, digits_per_comma=3, comma_string="."));
			r2 := tprint("%%", formatInt(b, digits_per_comma=3, comma_string="."));
		} else {
			r1, r2 := Day_%1.main();
		}
		t = get_time() - t;
		print(
			" (in %%s):\n  Part1: %%\n  Part2: %%\n\n",
			formatFloat(t, trailing_width=7), r1, r2
		);
	}
	reset_temporary_storage();
}
			XX
			array_add(*runs, tprint(format, last));
		}

		quick_sort(runs, compare_strings);
		for runs append(*builder, it);

		return builder_to_string(*builder);
	}

	args := get_command_line_arguments();
	run_day := ifx args.count > 1 then string_to_int(args[1]) else -1;
	init_time();

	#insert #run get_run();
}

#import "Sort";
#import "Basic";
#import "Compiler";
#import "File_Utilities";