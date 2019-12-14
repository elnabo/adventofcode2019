package days;

typedef Range = {min:Int, max:Int};

class Day4 {
	static final pow = [1, 10, 100, 1000, 10000, 100000];

	public static function run() {
		Sys.println("Advent of Code 2019: Day4");
		Sys.println("Part1: " + part1());
		Sys.println("Part2: " + part2());
	}

	static function getData():Range {
		return {min: 178416, max: 676461}
	}

	static function expand(number:Int, last:Int, length:Int, uniqueRemaining:Int, range:Range, ?repeated:Array<Int> = null) {
		if (number > range.max || uniqueRemaining <= 0) {
			return 0;
		}

		if (length == 0) {
			if (number < range.min) {
				return 0;
			}
			if (repeated != null) {
				return repeated.indexOf(2) == -1 ? 0 : 1;
			}
			return 1;
		}
		var c = 0;
		var l = length - 1;
		for (i in last...10) {
			var r = repeated;
			if (repeated != null) {
				r = repeated.copy();
				if (i == last) {
					r[repeated.length - 1]++;
				} else {
					r.push(1);
				}
			}
			var n = number + i * pow[l];
			c += expand(n, i, l, i == last ? uniqueRemaining : uniqueRemaining - 1, range, r);
		}
		return c;
	}

	static function part1() {
		var range = getData();
		var length = 6;
		var count = 0;
		for (i in 1...10) {
			count += expand(i * pow[length - 1], i, length - 1, length - 1, range);
		}
		return count;
	}

	static function part2() {
		var range = getData();
		var length = 6;
		var count = 0;
		for (i in 1...10) {
			count += expand(i * pow[length - 1], i, length - 1, length - 1, range, [1]);
		}
		return count;
	}
}
