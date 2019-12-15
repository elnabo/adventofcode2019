package days;

import sys.io.File;

using Lambda;

class Day8 {
	public static function run() {
		Sys.println("Advent of Code 2019: Day8");
		Sys.println("Part1: " + part1());
		Sys.println("Part2: " + part2());
	}

	static var w = 25;
	static var h = 6;

	static function getData():Array<Int> {
		return File.getContent("./data/day8.txt")
			.split('')
			.map(Std.parseInt)
			.filter(x -> x != null);
	}

	static function separateLayers(data:Array<Int>):Array<Array<Int>> {
		var layers = [];
		var layer = [];
		for (i in 0...data.length) {
			if (i > 0 && i % (h * w) == 0) {
				layers.push(layer);
				layer = [];
			}
			layer.push(data[i]);
		}
		layers.push(layer);
		return layers;
	}

	static function count(layer:Array<Int>, value:Int):Int {
		var c = 0;
		for (v in layer) {
			if (v == value) {
				c++;
			}
		}
		return c;
	}

	static function part1() {
		var data = getData();
		var layers = separateLayers(data);
		var min = h * w;
		var chosenLayer = null;
		for (layer in layers) {
			var c = count(layer, 0);
			if (c < min) {
				min = c;
				chosenLayer = layer;
			}
		}
		return count(chosenLayer, 1) * count(chosenLayer, 2);
	}

	static function decodePixel(i:Int, layers:Array<Array<Int>>, id:Int = 0):String {
		if (id >= layers.length) {
			return ' ';
		}
		return switch (layers[id][i]) {
			case 0: return ' ';
			case 1: return '0';
			case 2: return decodePixel(i, layers, id + 1);
			default: return null;
		}
	}

	static function decodeImage(layers:Array<Array<Int>>):Array<String> {
		var image = [];
		for (i in 0...h * w) {
			image.push(decodePixel(i, layers));
		}
		return image;
	}

	static function part2() {
		var data = getData();
		var layers = separateLayers(data);
		var image = decodeImage(layers);
		var row = '';
		for (i in 0...image.length) {
			if (i % w == 0) {
				// Sys.println(row);
				row = '';
			}
			row += image[i];
		}
		// Sys.println(row);
		return 'HGCBF';
	}
}
