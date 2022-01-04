fn day1() {

	fn part1(input: &String) {
		let mut sum : u32 = 0;
		let input_bytes = input.as_bytes();
		for i in 0..input_bytes.len() {
			let curr = input_bytes[i];
			let next = input_bytes[(i + 1) % input_bytes.len()];

			if curr == next {
				sum += (curr - ('0' as u8)) as u32;
			}
		}

		println!("{}", sum);
	}
	fn part2(input: &String) {
		let mut sum : u32 = 0;
		let input_bytes = input.as_bytes();
		let stride = input_bytes.len() / 2;
		for i in 0..input_bytes.len() {
			let curr = input_bytes[i];
			let next = input_bytes[(i + stride) % input_bytes.len()];

			if curr == next {
				sum += (curr - ('0' as u8)) as u32;
			}
		}

		println!("{}", sum);
	}

	let file_result = std::fs::read_to_string("inputs/01.txt");
	match file_result {
		Ok(input) => {
			part1(&input);
			part2(&input);
		}
		Err(error) => {
			println!("Error reading file: {}", error.to_string());
		}
	}
}

fn main() {
	day1();
}