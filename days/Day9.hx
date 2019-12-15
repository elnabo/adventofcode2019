package days;

import shared.IntCodeMachine;
import sys.io.File;

using StringTools;

class Day9 {
	public static function run() {
		Sys.println("Advent of Code 2019: Day9");
		Sys.println("Part1: " + part1());
		Sys.println("Part2: " + part2());
	}

	static function getData():Array<Float> {
		return File.getContent("./data/day9.txt")
			.split(',')
			.filter(x -> x.trim() != '')
			.map(Std.parseFloat);
	}

	static function part1() {
		var data = getData();
		var machine = new IntCodeMachine(data, [1]);
		machine.run();
		return machine.output[0];
	}

	static function part2() {
		var data = getData();
		var machine = new IntCodeMachine(data, [2]);
		machine.run();
		return machine.output[0];
	}
}
