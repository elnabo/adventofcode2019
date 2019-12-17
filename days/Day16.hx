package days;

import sys.io.File;

using Lambda;

class Day16 {
	public static function run() {
		Sys.println("Advent of Code 2019: Day16");
		// Sys.println("Part1: " + part1());
		Sys.println("Part2: " + part2());
	}

	static inline function abs(i:Int) {
		return i < 0 ? -1 * i : i;
	}

	static function getData():Array<Int> {
		return File.getContent("./data/day16.txt")
			.split('')
			.map(Std.parseInt)
			.filter(x -> x != null);
	}

	static final pattern = [0, 1, 0, -1];

	static function step(data:Array<Int>, s:Int) {
		var value = 0;
		for (i in 0...data.length) {
			var index = Std.int((i + 1) / s) % pattern.length;
			value += data[i] * pattern[index];
		}
		return abs(value) % 10;
	}

	static function applyFilter(data:Array<Int>) {
		return [for (s in 1...data.length + 1) step(data, s)];
	}

	static function part1() {
		var data = getData();
		for (i in 0...100) {
			data = applyFilter(data);
		}
		data.resize(8);
		return data.map(Std.string).join('');
	}

	static function part2() {
		var data = getData();
		var offset = Std.parseInt(data.slice(0, 7).join(''));

		var bigData = [];
		for (i in offset...data.length * 10000) {
			bigData.push(data[i % data.length]);
		}

		for (_ in 0...100) {
			var i = bigData.length - 2;
			while (i >= 0) {
				bigData[i] = (bigData[i] + bigData[i + 1]) % 10;
				i--;
			}
		}

		return bigData.slice(0, 8).join('');
	}
}
