package days;

import shared.IntCodeMachine;
import sys.io.File;

using StringTools;

enum abstract Tile(Int) from Int to Int {
	var Wall = 0;
	var Empty = 1;
	var Oxygen = 2;
	var Unknown = 99;
}

enum abstract Direction(Int) from Int to Int {
	var North = 1;
	var South = 2;
	var West = 3;
	var East = 4;
}

typedef Point = {x:Int, y:Int};
typedef ExploreTarget = {pos:Point, path:Array<Direction>};
typedef GMap = Map<Int, Map<Int, Tile>>;
typedef DMap = Map<Int, Map<Int, Int>>;

class Day15 {
	public static function run() {
		Sys.println("Advent of Code 2019: Day15");
		Sys.println("Part1: " + part1());
		Sys.println("Part2: " + part2());
	}

	static function getData():Array<Float> {
		return File.getContent("./data/day15.txt")
			.split(',')
			.filter(x -> x.trim() != '')
			.map(Std.parseFloat);
	}

	static function getNeighborsOf(p:ExploreTarget) {
		return [
			{pos: {x: p.pos.x, y: p.pos.y - 1}, path: p.path.concat([North])},
			{pos: {x: p.pos.x, y: p.pos.y + 1}, path: p.path.concat([South])},
			{pos: {x: p.pos.x - 1, y: p.pos.y}, path: p.path.concat([West])},
			{pos: {x: p.pos.x + 1, y: p.pos.y}, path: p.path.concat([East])}
		];
	}

	static function explore(map:GMap, distance:DMap, target:ExploreTarget, tile:Tile) {
		var point = target.pos;
		if (!map.exists(point.y)) {
			map[point.y] = new Map<Int, Tile>();
			distance[point.y] = new Map<Int, Int>();
		}
		map[point.y][point.x] = tile;
		var d = distance[point.y].exists(point.x) ? distance[point.y][point.x] : 9999;
		distance[point.y][point.x] = target.path.length < d ? target.path.length : d;

	}

	static function at (map:GMap, point:Point) {
		if (!map.exists(point.y) || !map[point.y].exists(point.x)) {
			return Unknown;
		}
		return map[point.y][point.x];
	}

	static function goto(map:GMap, target:ExploreTarget, data:Array<Float>) {
		var machine = new IntCodeMachine(data, []);
		for (dir in target.path) {
			machine.feed(dir);
			machine.waitOutput();
		}
		return machine.output[target.path.length - 1];
	}

	static function addUnexplored(map:GMap, distance:DMap, curr:ExploreTarget, opened:Array<ExploreTarget>) {
		var neigh = getNeighborsOf(curr);
		for (n in neigh) {
			switch (at(map, n.pos)) {
				case Empty, Oxygen:
					if (distance[n.pos.y][n.pos.x] > n.path.length) {
						opened.push(n);
					}
				case Unknown:
					opened.push(n);
				default:
			}
		}
	}

	static var oxygenPath:Array<Direction>;

	static function part1() {
		//var data = getData();
		var map:GMap = [];
		var distance:DMap = [];

		var start = {pos: {x:0, y:0}, path: []};
		explore(map, distance, start, Empty);
		var opened = getNeighborsOf(start);
		var oxygen = null;
		while (opened.length > 0) {
			var curr = opened.shift();
			var out:Tile = cast goto(map, curr, getData());
			explore(map, distance, curr, out);
			if ( out != Wall) {
				addUnexplored(map, distance, curr, opened);
			}
			if (out == Oxygen) {
				oxygen = curr;
			}
		}
		oxygenPath = oxygen.path;
		return oxygen.path.length;
	}

	static function part2() {
		var map:GMap = [];
		var distance:DMap = [];

		var machine = new IntCodeMachine(getData(), []);
		for (dir in oxygenPath) {
			machine.feed(dir);
			machine.waitOutput();
		}

		var start = {pos: {x:0, y:0}, path: []};
		explore(map, distance, start, Empty);
		var opened = getNeighborsOf(start);
		var oxygen = null;
		while (opened.length > 0) {
			var curr = opened.shift();

			var out:Tile = cast goto(map, curr, machine.copyMemory());
			explore(map, distance, curr, out);
			if ( out != Wall) {
				addUnexplored(map, distance, curr, opened);
			}
			if (out == Oxygen) {
				oxygen = curr;
			}
		}

		var xMin = 0;
		var xMax = 0;
		var yMin = 0;
		var yMax = 0;
		for ( k=>v in distance) {
			if (k < yMin) {
				yMin = k;
			}
			else if (k > yMax ) {
				yMax = k;
			}
			for ( k1 in v.keys()) {
				if (k1 < xMin) {
					xMin = k1;
				}
				else if (k1 > xMax) {
					xMax = k1;
				}
			}
		}

		yMax++;
		xMax++;
		for ( y in yMin...yMax) {
			var str = '';
			for ( x in xMin...xMax) {
				switch (at(map, {x:x, y:y})) {
					case Wall:
						str += 'x   ';
					case Empty:
						str += (''+distance[y][x]).rpad(" ", 4);
					case Oxygen:
						str += 'O   ';
					default:
						str += 'u   ';
				}
			}
			Sys.println(str);
		}

		var max = 0;
		for ( row in distance ) {
			for ( d in row ) {
				if ( d > max ) {
					max = d;
				}
			}
		}
		return max;
	}
}
