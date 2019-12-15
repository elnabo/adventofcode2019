package days;

import shared.IntCodeMachine;
import sys.io.File;

using StringTools;

enum Direction {
	Left;
	Right;
	Up;
	Down;
}

typedef Robot = {x:Int, y:Int, dir:Direction};

class Day11 {
	public static function run() {
		Sys.println("Advent of Code 2019: Day11");
		Sys.println("Part1: " + part1());
		Sys.println("Part2: " + part2());
	}

	static function getData():Array<Float> {
		return File.getContent("./data/day11.txt")
			.split(',')
			.filter(x -> x.trim() != '')
			.map(Std.parseFloat);
	}

	static function part1() {
		var data = getData();
		var machine = new IntCodeMachine(data, [0]);

		var painted = new Map<String, Int>();
		var robot = {x: 0, y: 0, dir: Up};

		while (true) {
			machine.waitOutput();
			machine.waitOutput();
			if (machine.output.length == 0) {
				break;
			}
			var color = machine.output[0];
			var direction = machine.output[1];

			paint(robot, Std.int(color), painted);
			moveRobot(robot, Std.int(direction));

			machine.input.push(see(robot, painted));
			machine.output = [];
		}
		return Lambda.count(painted);
	}

	static inline function key(robot:Robot) {
		return robot.x + '~' + robot.y;
	}

	static function see(robot:Robot, painted:Map<String, Int>) {
		var k = key(robot);
		if (painted.exists(k)) {
			return painted[k];
		}
		return 0;
	}

	static function paint(robot:Robot, color:Int, painted:Map<String, Int>) {
		painted[key(robot)] = color;
	}

	static function moveRobot(robot:Robot, direction:Int) {
		var nextDir = switch (robot.dir) {
			case Left: direction == 0 ? Down : Up;
			case Right: direction == 1 ? Down : Up;
			case Up: direction == 0 ? Left : Right;
			case Down: direction == 1 ? Left : Right;
		}
		robot.dir = nextDir;

		switch (nextDir) {
			case Left:
				--robot.x;
			case Right:
				++robot.x;
			case Up:
				--robot.y;
			case Down:
				++robot.y;
		}
	}

	static function part2() {
		var data = getData();
		var machine = new IntCodeMachine(data, [1]);

		var painted = new Map<String, Int>();
		var robot = {x: 0, y: 0, dir: Up};
		paint(robot, 1, painted);

		var xmin = 0;
		var xmax = 0;
		var ymin = 0;
		var ymax = 0;

		while (true) {
			machine.waitOutput();
			machine.waitOutput();
			if (machine.output.length == 0) {
				break;
			}
			var color = machine.output[0];
			var direction = machine.output[1];

			paint(robot, Std.int(color), painted);
			moveRobot(robot, Std.int(direction));

			if (robot.x < xmin) {
				xmin = robot.x;
			} else if (robot.x > xmax) {
				xmax = robot.x;
			}

			if (robot.y < ymin) {
				ymin = robot.y;
			} else if (robot.y > ymax) {
				ymax = robot.y;
			}

			machine.input.push(see(robot, painted));
			machine.output = [];
		}

		xmax++;
		ymax++;

		for (y in ymin...ymax) {
			var s = '';
			for (x in xmin...xmax) {
				var r = {x: x, y: y, dir: Up};
				var c = see(r, painted);
				s += c == 0 ? ' ' : 'o';
			}
			Sys.println(s);
		}

		return null;
	}
}
