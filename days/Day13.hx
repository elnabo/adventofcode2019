package days;

import shared.IntCodeMachine;
import sys.io.File;

using StringTools;

enum abstract Tile(Int) from Int to Int {
	var Empty = 0;
	var Wall = 1;
	var Block = 2;
	var HPaddle = 3;
	var Ball = 4;
}

class Day13 {
	public static function run() {
		Sys.println("Advent of Code 2019: Day13");
		Sys.println("Part1: " + part1());
		Sys.println("Part2: " + part2());
	}

	static function getData():Array<Float> {
		return File.getContent("./data/day13.txt")
			.split(',')
			.filter(x -> x.trim() != '')
			.map(Std.parseFloat);
	}

	static var map:Array<Array<Tile>> = [];
	static var width = 0;
	static var height = 0;

	static function addToMap(x:Int, y:Int, t:Tile) {
		if (y <= height) {
			map.push([for (_ in 0...width) Empty]);
		}

		if (x <= width) {
			for (row in map) {
				while (row.length <= x) {
					row.push(Empty);
				}
			}
		}

		map[y][x] = t;
	}

	static function part1() {
		var data = getData();
		var machine = new IntCodeMachine(data, [0]);
		while (true) {
			machine.waitOutput(3);
			final out = machine.readOutput();
			if (out.length != 3) {
				break;
			}
			var x = Std.int(out[0]);
			var y = Std.int(out[1]);
			var t = Std.int(out[2]);
			addToMap(x, y, t);
		}
		var count = 0;
		for (row in map) {
			for (tile in row) {
				if (tile == Block) {
					count++;
				}
			}
		}
		return count;
	}

	static function part2() {
		var data = getData();
		data[0] = 2;
		var machine = new IntCodeMachine(data, []);

		var paddleX = 0;
		var score = 0;
		while (true) {
			machine.waitOutput(3);
			final out = machine.readOutput();
			if (out.length != 3) {
				break;
			}
			var x = Std.int(out[0]);
			var t = Std.int(out[2]);
			if (x < 0) {
				score = t;
			} else {
				switch (t) {
					case Ball:
						machine.feed(Reflect.compare(x, paddleX));
					case HPaddle:
						paddleX = x;
				}
			}
		}
		return score;
	}
}
