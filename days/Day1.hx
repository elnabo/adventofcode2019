package days;

import sys.io.File;

using Lambda;

class Day1 {
	public static function run() {
		Sys.println("Advent of Code 2019: Day1");
		Sys.println("Part1: " + part1());
		Sys.println("Part2: " + part2());
	}

	static function getData():Array<Int> {
		return File.getContent("./data/day1.txt")
			.split('\n')
			.map(Std.parseInt)
			.filter(x -> x != null);
	}

	static inline function getFuelOf(x:Int) {
		return Math.floor(x / 3) - 2;
	}

	static function part1() {
		return getData().map(getFuelOf).fold((x, res) -> x + res, 0);
	}

	static function part2() {
		var data = getData();
		var totalFuel = 0;
		for (module in data) {
			var addition = getFuelOf(module);
			while (addition > 0) {
				totalFuel += addition;
				addition = getFuelOf(addition);
			}
		}
		return totalFuel;
	}
}
