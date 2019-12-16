package days;

typedef Vec3 = Array<Int>;
typedef Planet = {pos:Vec3, vel:Vec3};

class Day12 {
	public static function run() {
		Sys.println("Advent of Code 2019: Day12");
		Sys.println("Part1: " + part1());
		Sys.println("Part2: " + part2());
	}

	static inline function abs(i:Int) {
		return i < 0 ? -1 * i : i;
	}

	static function vec3Energy(vec:Vec3) {
		var e = 0;
		for (v in vec) {
			e += abs(v);
		}
		return e;
	}

	static function getData():Array<Planet> {
		return [
			{
				pos: [17, 5, 1],
				vel: [0, 0, 0]
			},
			{
				pos: [-2, -8, 8],
				vel: [0, 0, 0]
			},
			{
				pos: [7, -6, 14],
				vel: [0, 0, 0]
			},
			{pos: [1, -10, 4], vel: [0, 0, 0]}
		];
	}

	static function updateVelocity(system:Array<Planet>, min:Int, max:Int) {
		for (p in system) {
			for (op in system) {
				for (i in min...max) {
					if (p.pos[i] < op.pos[i]) {
						p.vel[i]++;
					} else if (p.pos[i] > op.pos[i]) {
						p.vel[i]--;
					}
				}
			}
		}
	}

	static function updatePosition(system:Array<Planet>, min:Int, max:Int) {
		for (p in system) {
			for (i in min...max) {
				p.pos[i] += p.vel[i];
			}
		}
	}

	static function energy(system:Array<Planet>) {
		var e = 0;
		for (p in system) {
			e += vec3Energy(p.pos) * vec3Energy(p.vel);
		}
		return e;
	}

	static function part1() {
		var system = getData();
		for (_ in 0...1000) {
			updateVelocity(system, 0, 3);
			updatePosition(system, 0, 3);
		}
		return energy(system);
	}

	static function isInitial(system:Array<Planet>, orig:Array<Planet>, i:Int) {
		for (j in 0...system.length) {
			var p = system[j];
			var o = orig[j];
			if (p.pos[i] != o.pos[i] || p.vel[i] != o.vel[i]) {
				return false;
			}
		}
		return true;
	}

	static function gcd(a:Float, b:Float) {
		while (b > 0) {
			var tmp = a;
			a = b;
			b = tmp % b;
		}
		return a;
	}

	static function lcm(a:Float, b:Float):Float {
		return (a * b) / gcd(a, b);
	}

	static function part2() {
		var systemOrig = getData();
		var system = getData();
		var cycles = [0.0, 0.0, 0.0];
		for (i in 0...system[0].pos.length) {
			do {
				updateVelocity(system, i, i + 1);
				updatePosition(system, i, i + 1);
				cycles[i]++;
			} while (!isInitial(system, systemOrig, i));
		}
		return lcm(cycles[0], lcm(cycles[1], cycles[2]));
	}
}
