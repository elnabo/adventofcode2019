package shared;

enum OpCode {
	Add;
	Multiply;
	Halt;
	Invalid;
}

class IntCodeMachine {
	final memory:Array<Int>;
	var pc:Int = 0;
	var stopped = false;

	public function new(memory:Array<Int>) {
		this.memory = memory;
	}

	function nextOpCode():OpCode {
		return switch (next()) {
			case 1:
				Add;
			case 2:
				Multiply;
			case 99:
				Halt;
			default:
				Invalid;
		}
	}

	inline function next() {
		return at(pc++);
	}

	inline function write(value:Int, address:Int) {
		memory[address] = value;
	}

	inline function halt() {
		stopped = true;
	}

	public inline function at(address:Int):Int {
		return memory[address];
	}

	public function run() {
		while (!stopped) {
			step();
		}
	}

	public function step() {
		if (stopped) {
			return;
		}
		switch (nextOpCode()) {
			case Add:
				final a:Int = at(next());
				final b:Int = at(next());
				final c:Int = next();
				write(a + b, c);
			case Multiply:
				final a:Int = at(next());
				final b:Int = at(next());
				final c:Int = next();
				write(a * b, c);
			case Halt:
				halt();
			case Invalid:
				trace('Invalid opcode ${at(pc)} at address ${pc}');
				halt();
		}
	}
}
