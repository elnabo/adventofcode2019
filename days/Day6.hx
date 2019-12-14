package days;

import sys.io.File;

using StringTools;

typedef Graph = {vertices:Array<String>, adjacencyMap:Map<String, Array<String>>};

class Day6 {
	public static function run() {
		Sys.println("Advent of Code 2019: Day6");
		Sys.println("Part1: " + part1());
		Sys.println("Part2: " + part2());
	}

	static function computeChecksum(of:String, orbitMap:Map<String, Array<String>>, indirect:Int = 0) {
		var orbities = orbitMap[of];
		if (orbities == null) {
			return indirect;
		}

		var count = indirect;
		for (orb in orbities) {
			count += computeChecksum(orb, orbitMap, indirect + 1);
		}
		return count;
	}

	static function buildOrbitMap(data:Array<Array<String>>) {
		final orbitMap = new Map<String, Array<String>>();
		for (d in data) {
			if (!orbitMap.exists(d[0])) {
				orbitMap[d[0]] = [];
			}
			orbitMap[d[0]].push(d[1]);
		}
		return orbitMap;
	}

	static function buildOrbitingGraph(data:Array<Array<String>>) {
		final vertices = new Array<String>();
		final adjacencyMap = new Map<String, Array<String>>();

		for (orbit in data) {
			var o1 = orbit[0];
			var o2 = orbit[1];
			vertices.push(o1);
			vertices.push(o2);
			if (!adjacencyMap.exists(o1)) {
				adjacencyMap[o1] = [];
			}
			if (!adjacencyMap.exists(o2)) {
				adjacencyMap[o2] = [];
			}
			adjacencyMap[o1].push(o2);
			adjacencyMap[o2].push(o1);
		}

		return {vertices: vertices, adjacencyMap: adjacencyMap};
	}

	static function distanceBetween(a:String, b:String, graph:Graph) {
		var closed = new Map<String, Bool>();
		var opened = [a];
		var distance = 0;

		while (opened.length > 0) {
			var next = [];
			for (o in opened) {
				next = next.concat(graph.adjacencyMap[o]);
				closed[o] = true;
			}
			opened = [];
			for (n in next) {
				if (n == b) {
					return distance;
				}
				if (!closed.exists(n)) {
					opened.push(n);
				}
			}
			distance++;
		}
		return null;
	}

	static function getData():Array<Array<String>> {
		return File.getContent("./data/day6.txt")
			.split('\n')
			.filter(x -> x.trim() != '')
			.map(x -> x.split(')'));
	}

	static function part1() {
		var data = getData();
		return computeChecksum('COM', buildOrbitMap(data));
	}

	static function part2() {
		final data = getData();
		return distanceBetween('YOU', 'SAN', buildOrbitingGraph(data)) - 1;
	}
}
