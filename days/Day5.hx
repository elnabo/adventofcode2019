package days;

import shared.IntCodeMachine;
import sys.io.File;

using StringTools;

class Day5 {
	public static function run() {
		Sys.println("Advent of Code 2019: Day5");
		Sys.println("Part1: " + part1());
		Sys.println("Part2: " + part2());
	}

	static function getData() {
		return File.getContent("./data/day5.txt")
			.split(',')
			.filter(x -> x.trim() != '')
			.map(Std.parseFloat);
	}

	static function part1() {
		var data = getData();
		var machine = new IntCodeMachine(data, [1]);
		machine.run();
		return machine.output[machine.output.length - 1];
	}

	static function part2() {
		var data = getData();
		var machine = new IntCodeMachine(data, [5]);
		machine.run();
		return machine.output[machine.output.length - 1];
	}
}
