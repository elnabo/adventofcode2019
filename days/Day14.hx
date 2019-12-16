package days;

import sys.io.File;

using StringTools;

typedef Element = {name:String, quantity:Float};
typedef Receipe = {produced:Element, of:Array<Element>};

class Day14 {
	public static function run() {
		Sys.println("Advent of Code 2019: Day14");
		Sys.println("Part1: " + part1());
		Sys.println("Part2: " + part2());
	}

	static function parseElement(s:String):Element {
		s = s.trim();
		var split = s.split(' ');
		return {name: split[1], quantity: Std.parseFloat(split[0])};
	}

	static function getData():Array<Receipe> {
		var rawReceipes = File.getContent("./data/day14.txt").split('\n').filter(x -> x.trim() != '');
		var receipes = [];
		for (r in rawReceipes) {
			var part = r.split('=>');
			receipes.push({produced: parseElement(part[1]), of: part[0].split(',').map(parseElement)});
		}
		return receipes;
	}

	static function queryOre(of:String, quantity:Float, cookbook:Map<String, Receipe>, exact:Bool = true) {
		var want = [of];
		var quantities = [of => quantity];

		while (want.length > 0) {
			var e = want.shift();
			var q = quantities[e];
			if (q <= 0) {
				continue;
			}
			var r = cookbook[e];
			var factor = q / r.produced.quantity;
			if (exact) {
				factor = Math.fceil(factor);
			}

			quantities[e] = q - factor * r.produced.quantity;

			for (elt in r.of) {
				var w = factor * elt.quantity;
				var name = elt.name;
				if (name != 'ORE') {
					want.push(name);
				}
				if (quantities.exists(name)) {
					quantities[name] += w;
				} else {
					quantities[name] = w;
				}
			}
		}
		return quantities['ORE'];
	}

	static function part1() {
		var data = getData();
		var cookbook = new Map<String, Receipe>();
		for (r in data) {
			cookbook[r.produced.name] = r;
		}

		return queryOre('FUEL', 1, cookbook);
	}

	static function part2() {
		var data = getData();
		var cookbook = new Map<String, Receipe>();
		for (r in data) {
			cookbook[r.produced.name] = r;
		}

		var trillion = 1000000000000;
		var approxCostOfOneFuel = queryOre('FUEL', 1, cookbook, false);
		var approxFuelForATrillion = Math.floor(trillion / approxCostOfOneFuel);
		return queryOre('FUEL', approxFuelForATrillion, cookbook) > trillion ? approxFuelForATrillion - 1 : approxFuelForATrillion;
	}
}
