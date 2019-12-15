package days;

import shared.IntCodeMachine;
import sys.io.File;

using StringTools;

class Day2 {
	public static function run() {
		Sys.println("Advent of Code 2019: Day2");
		Sys.println("Part1: " + part1());
		Sys.println("Part2: " + part2());
	}

	static function getData():Array<Float> {
		return File.getContent("./data/day2.txt")
			.split(',')
			.filter(x -> x.trim() != '')
			.map(Std.parseFloat);
	}

	static function part1() {
		var data = getData();
		data[1] = 12;
		data[2] = 2;
		var machine = new IntCodeMachine(data);
		machine.run();
		return machine.at(0);
	}

	static function part2() {
		final data = getData();
		for (noun in 0...99) {
			for (verb in 0...99) {
				final program = [for (d in data) d];
				program[1] = noun;
				program[2] = verb;
				var machine = new IntCodeMachine(program);
				machine.run();
				if (machine.at(0) == 19690720) {
					return 100 * noun + verb;
				}
			}
		}
		return null;
	}
}
