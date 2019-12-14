package days;

import sys.io.File;

using Lambda;

typedef Point = {x:Int, y:Int}
typedef Segment = {start:Point, end:Point, vertical:Bool, length:Int};
typedef Path = Array<Segment>;

class Day3 {
	public static function run() {
		Sys.println("Advent of Code 2019: Day3");
		Sys.println("Part1: " + part1());
		Sys.println("Part2: " + part2());
	}

	static function parseMovement(movment:String):Point {
		final first = movment.charAt(0);
		final value = Std.parseInt(movment.substr(1));
		if (value == null) {
			return null;
		}
		return switch (first) {
			case 'U':
				return {x: 0, y: -value};
			case 'D':
				return {x: 0, y: value};
			case 'R':
				return {x: value, y: 0};
			case 'L':
				return {x: -value, y: 0};
			default:
				return null;
		}
	}

	static function getPath(data:String):Path {
		var points = data.split(',').map(parseMovement).filter(x -> x != null);
		var curr = {x: 0, y: 0};
		var segments = [];
		for (p in points) {
			var next = {x: curr.x + p.x, y: curr.y + p.y};
			segments.push({
				start: curr,
				end: next,
				vertical: p.x == 0,
				length: Std.int(Math.abs(p.x + p.y))
			});
			curr = next;
		}
		return segments;
	}

	static function getData():Array<Path> {
		return File.getContent("./data/day3.txt").split('\n').map(getPath);
	}

	static inline function areParallel(a:Segment, b:Segment):Bool {
		return a.vertical == b.vertical;
	}

	static inline function between(v, p1, p2) {
		return v >= Math.min(p1, p2) && v <= Math.max(p1, p2);
	}

	static function getIntersection(a:Segment, b:Segment):Point {
		if (areParallel(a, b)) {
			return null;
		}

		var v = a.vertical ? a : b;
		var h = a.vertical ? b : a;

		if (between(v.start.x, h.start.x, h.end.x) && between(h.start.y, v.start.y, v.end.y)) {
			return {x: v.start.x, y: h.start.y};
		}
		return null;
	}

	static function part1() {
		var data = getData();
		var line1 = data[0];
		var line2 = data[1];

		var min = -1;
		for (s1 in line1) {
			for (s2 in line2) {
				var intersect = getIntersection(s1, s2);
				if (intersect != null) {
					var d = Math.abs(intersect.x) + Math.abs(intersect.y);
					if (min < 0 || d < min) {
						min = Std.int(d);
					}
				}
			}
		}
		return min;
	}

	static inline function length(start, end) {
		return Std.int(Math.abs(start.x - end.x) + Math.abs(start.y - end.y));
	}

	static function part2() {
		var data = getData();
		var line1 = data[0];
		var line2 = data[1];

		var min = -1;
		var s1Steps = 0;
		for (s1 in line1) {
			var s2Steps = 0;
			for (s2 in line2) {
				var intersect = getIntersection(s1, s2);
				if (intersect != null) {
					var d = s1Steps + s2Steps + length(s1.start, intersect) + length(s2.start, intersect);
					if (min < 0 || d < min) {
						min = d;
					}
				}
				s2Steps += s2.length;
			}
			s1Steps += s1.length;
		}
		return min;
	}
}
