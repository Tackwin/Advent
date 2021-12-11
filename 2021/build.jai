#import "Sort";
#import "Basic";
#import "Compiler";
#import "File_Utilities";

build :: () {
	set_working_directory(#filepath);

	{
		w := compiler_create_workspace("Main");

		import : [..] string;

		opts := get_build_options();

		opts.output_executable_name = "advent";

		for opts.import_path array_add(*import, it);
		array_add(*import, #filepath);
		opts.import_path = import;

		set_build_options(opts, w);


		add_build_file(tprint("%/main.jai", #filepath), w);
	}

	set_build_options_dc(.{do_output = false});
}

#run build();