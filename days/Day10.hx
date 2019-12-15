package days;

import sys.io.File;

using Lambda;
using StringTools;

typedef Point = {x:Float, y:Float};

class Day10 {
	public static function run() {
		Sys.println("Advent of Code 2019: Day10");
		Sys.println("Part1: " + part1());
		Sys.println("Part2: " + part2());
	}

	static function getData() {
		// 		return '.#..##.###...#######
		// ##.############..##.
		// .#.######.########.#
		// .###.#######.####.#.
		// #####.##.#.##.###.##
		// ..#####..#.#########
		// ####################
		// #.####....###.#.#.##
		// ##.#################
		// #####.##.###..####..
		// ..######..##.#######
		// ####.##.####...##..#
		// .#####..#.######.###
		// ##...#.##########...
		// #.##########.#######
		// .####.#.###.###.#.##
		// ....##.##.###..#####
		// .#.#.###########.###
		// #.#.#.#####.####.###
		// ###.##.####.##.#..##'.split('\n')
		// 			.filter(x -> x.trim() != '')
		// 			.map(x -> x.split(''));
		return File.getContent("./data/day10.txt")
			.split('\n')
			.filter(x -> x.trim() != '')
			.map(x -> x.split(''));
	}

	static function distance(a:Point, b:Point):Float {
		var x = a.x - b.x;
		var y = a.y - b.y;
		return Math.sqrt(x * x + y * y);
	}

	static function between(a:Point, b:Point, c:Point) {
		return Math.abs(distance(a, b) + distance(b, c) - distance(a, c)) < 0.000000001;
	}

	static function getVisibleFrom(location:Point, asteroids:Array<Point>) {
		var possible = asteroids.copy();
		possible.remove(location);
		var i = 0;
		while (i < possible.length) {
			var p = possible[i];
			for (e in asteroids) {
				if (e == p || e == location) {
					continue;
				} else if (between(location, e, p)) {
					possible.remove(p);
					i--;
					break;
				}
			}
			i++;
		}
		return possible;
	}

	static function part1() {
		// var data = getData();
		// final asteroids:Array<Point> = [];
		// for (y in 0...data.length) {
		// 	for (x in 0...data[0].length) {
		// 		var p = {x: x, y: y};
		// 		if (data[y][x] == '#') {
		// 			asteroids.push(p);
		// 		}
		// 	}
		// }

		// var max = 0;
		// for (p in asteroids) {
		// 	var c = getVisibleFrom(p, asteroids).length;
		// 	if (c > max) {
		// 		max = c;
		// 	}
		// }
		// return max;
		return 280;
	}

	static function getAngle(location, other) {
		var d = distance(location, other);
		var vec1 = {x: 0, y: -1};
		var vec2 = {x: (other.x - location.x) / d, y: (other.y - location.y) / d};
		var dotProduct = vec1.x * vec2.x + vec1.y * vec2.y;
		var acos = Math.acos(dotProduct);
		if (vec2.x < 0) {
			return 2 * Math.PI - acos;
		}
		return acos;
	}

	static function part2() {
		var data = getData();
		final asteroids:Array<Point> = [];
		for (y in 0...data.length) {
			for (x in 0...data[0].length) {
				var p:Point = {x: x, y: y};
				if (data[y][x] == '#') {
					asteroids.push(p);
				}
			}
		}
		var location = asteroids[311];
		var visible = getVisibleFrom(location, asteroids);
		var angles = visible.map(v -> getAngle(location, v));
		var orig = angles.copy();
		angles.sort(Reflect.compare);
		var bet = visible[orig.indexOf(angles[199])];
		return bet;
	}
}
