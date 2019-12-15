package days;

import shared.IntCodeMachine;
import sys.io.File;

using StringTools;

class Day7 {
	public static function run() {
		Sys.println("Advent of Code 2019: Day7");
		Sys.println("Part1: " + part1());
		Sys.println("Part2: " + part2());
	}

	static function getData() {
		return File.getContent("./data/day7.txt")
			.split(',')
			.filter(x -> x.trim() != '')
			.map(Std.parseFloat);
	}

	// heaps algorithm
	static function _getCombinations(k:Int, a:Array<Int>, results:Array<Array<Int>>) {
		if (k == 1) {
			results.push(a.copy());
		} else {
			_getCombinations(k - 1, a, results);
			for (i in 0...k - 1) {
				var tmp = a[k - 1];
				if (k % 2 == 0) {
					a[k - 1] = a[i];
					a[i] = tmp;
				} else {
					a[k - 1] = a[0];
					a[0] = tmp;
				}
				_getCombinations(k - 1, a, results);
			}
		}
	}

	static function getCombinations():Array<Array<Int>> {
		var results = [];
		_getCombinations(5, [0, 1, 2, 3, 4], results);
		return results;
	}

	static function part1() {
		var data = getData();
		var max = 0;
		var bestCombi = null;
		for (c in getCombinations()) {
			var output = 0;
			for (input in c) {
				var machine = new IntCodeMachine(data, [input, output]);
				machine.run();
				output = Std.int(machine.output[0]);
			}
			if (output > max) {
				max = output;
				bestCombi = c;
			}
		}
		return max;
	}

	static function part2() {
		var data = getData();
		var max = 0;
		var bestCombi = null;
		for (c in getCombinations()) {
			var output = 0;
			var machines = [for (input in c) new IntCodeMachine(data, [input + 5])];
			var running = true;
			while (running) {
				for (m in machines) {
					m.input.push(output);
					var o = m.waitOutput();
					if (o == null) {
						running = false;
					} else {
						output = Std.int(o);
					}
				}
			}
			if (output > max) {
				max = output;
				bestCombi = c;
			}
		}
		return max;
	}
}
