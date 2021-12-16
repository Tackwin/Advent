#import "Basic";
#import "File";
#import "String";
#import "Sort";
#import "Hash_Table";
#import "Hash";

Packet :: struct {
	version : int;
	type_id : int;

	value : int;
	sub_count : int;
}

_String :: struct { s: string; };
String :: (s: string) -> _String { S: _String; S.s = s; return S; }

part1 :: (packets: [] Packet) -> int {
	s := 0;
	for packets s += it.version;
	return s;
}

part2 :: (packets: [] Packet) -> int {
	evaluate :: (packets: [] Packet, p: int) -> (int, int) {
		it := packets[p];
		n := 1;

		if it.type_id == {
			case 0;
				x := 0;
				for 1..it.sub_count {
					a, b := evaluate(packets, p + n);
					x += a;
					n += b;
				}
				return x, n;
			case 1;
				x := 1;
				for 1..it.sub_count {
					a, b := evaluate(packets, p + n);
					x *= a;
					n += b;
				}
				return x, n;
			case 2;
				x := 1 << 62;
				for 1..it.sub_count {
					a, b := evaluate(packets, p + n);
					x = min(x, a);
					n += b;
				}
				return x, n;
			case 3;
				x := -(1 << 62);
				for 1..it.sub_count {
					a, b := evaluate(packets, p + n);
					x = max(x, a);
					n += b;
				}
				return x, n;
			case 4;
				return it.value, n;
			case 5;
				a, b := evaluate(packets, p + n);
				c, d := evaluate(packets, p + n + b);
				return (ifx a > c 1 else 0), n + b + d;
			case 6;
				a, b := evaluate(packets, p + n);
				c, d := evaluate(packets, p + n + b);
				return (ifx a < c 1 else 0), n + b + d;
			case 7;
				a, b := evaluate(packets, p + n);
				c, d := evaluate(packets, p + n + b);
				return (ifx a == c 1 else 0), n + b + d;
		}
		return -1, n;
	}

	a, b := evaluate(packets, 0);
	return a;
}

main :: () -> (int, int) {
	input, success := read_entire_file("Inputs/16.txt");
	if !success {
		print("Error reading input\n");
		return -1, -1;
	}

	bits : [..]u8;
	array_resize(*bits, input.count * 4 / 8);

	set_bit_at :: (bits: [] u8, idx: int) {
		bits[idx / 8] |= cast(u8) (1 << (idx % 8));
	}
	get_bit_at :: (bits: [] u8, idx: int) -> int {
		return ifx (bits[idx / 8] & cast(u8) (1 << (idx % 8))) > 0 1 else 0;
	}

	for String(input) {
		if find_index_from_left("13579BDF", it) >= 0 set_bit_at(bits, it_index * 4 + 3);
		if find_index_from_left("2367ABEF", it) >= 0 set_bit_at(bits, it_index * 4 + 2);
		if find_index_from_left("4567CDEF", it) >= 0 set_bit_at(bits, it_index * 4 + 1);
		if find_index_from_left("89ABCDEF", it) >= 0 set_bit_at(bits, it_index * 4 + 0);
	}

	packets : [..] Packet;
	array_reserve(*packets, input.count);

	parse_packet :: (bits: [] u8, start: int, packets: *[..] Packet) -> int {
		idx := start;

		array_add(packets, .{});
		new_packet := *(<<packets)[packets.count - 1];
		new_packet.version |= get_bit_at(bits, idx) << 2; idx += 1;
		new_packet.version |= get_bit_at(bits, idx) << 1; idx += 1;
		new_packet.version |= get_bit_at(bits, idx) << 0; idx += 1;
		
		new_packet.type_id |= get_bit_at(bits, idx) << 2; idx += 1;
		new_packet.type_id |= get_bit_at(bits, idx) << 1; idx += 1;
		new_packet.type_id |= get_bit_at(bits, idx) << 0; idx += 1;

		if new_packet.type_id == 4 {
			p := 0; // Binary power

			while true {
				flag := get_bit_at(bits, idx); idx += 1;
				new_packet.value *= 16;
				new_packet.value |= get_bit_at(bits, idx) << 3; idx += 1;
				new_packet.value |= get_bit_at(bits, idx) << 2; idx += 1;
				new_packet.value |= get_bit_at(bits, idx) << 1; idx += 1;
				new_packet.value |= get_bit_at(bits, idx) << 0; idx += 1;

				if flag == 0 break;
			}
		} else {
			length_type_id := get_bit_at(bits, idx) << 0; idx += 1;

			if length_type_id == 0 {

				length := 0;
				for 0..14 { length *= 2; length += get_bit_at(bits, idx); idx += 1; }
				
				while length > 0 {
					add := parse_packet(bits, idx, packets);
					idx += add;
					length -= add;
					new_packet.sub_count += 1;
				}
			} else {
				for 0..10 {
					new_packet.sub_count *= 2;
					new_packet.sub_count += get_bit_at(bits, idx);
					idx += 1;
				}
				
				for 1..new_packet.sub_count {
					add := parse_packet(bits, idx, packets);
					idx += add;
				}
			}
		}
		
		return idx - start;
	}


	l := parse_packet(bits, 0, *packets);

	return part1(packets), part2(packets);
}



for_expansion :: (s: *_String, body: Code, flags: For_Flags) #expand {
	for idx: 0..s.s.count-1 {
		`it := s.s[idx];
		`it_index := idx;

		#insert body;
	}
};