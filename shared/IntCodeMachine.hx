package shared;

typedef OpCode = {code:Code, modes:Array<Mode>};

enum abstract Mode(Int) from Int to Int {
	var Position = 0;
	var Immediate = 1;
	var Relative = 2;
}

enum Code {
	Add;
	Multiply;
	Input;
	Output;
	JumpIfTrue;
	JumpIfFalse;
	LessThan;
	Equals;
	RBase;
	Halt;
	Invalid;
}

class IntCodeMachine {
	final memory:Array<Float>;
	var pc:Int = 0;
	var stopped = false;
	var relative = 0.0;

	public final input:Array<Int>;
	public var output = [];

	public function new(memory:Array<Float>, input:Array<Int> = null) {
		this.memory = memory;
		if (input == null) {
			throw 'behaviour changed pass [0] for the input parameter';
		}
		this.input = input;
	}

	function nextOpCode():OpCode {
		var ABCDE = next();
		var DE = ABCDE % 100;
		var code = switch (DE) {
			case 1:
				Add;
			case 2:
				Multiply;
			case 3:
				Input;
			case 4:
				Output;
			case 5:
				JumpIfTrue;
			case 6:
				JumpIfFalse;
			case 7:
				LessThan;
			case 8:
				Equals;
			case 9:
				RBase;
			case 99:
				Halt;
			default:
				Invalid;
		}

		var _mode = Std.int(ABCDE / 100);
		var modes:Array<Mode> = [Position, Position, Position];
		for (i in 0...3) {
			modes[i] = (cast _mode % 10);
			_mode = Std.int(_mode / 10);
		}
		return {code: code, modes: modes};
	}

	public inline function dump() {
		trace(memory, output);
	}

	inline function next() {
		return at(pc++);
	}

	inline function write(value:Float, address:Float) {
		while (memory.length < address + 1) {
			memory.push(0);
		}
		memory[Std.int(address)] = value;
	}

	inline function halt() {
		stopped = true;
	}

	inline function get(value:Float, mode:Mode):Float {
		return switch (mode) {
			case Immediate: value;
			case Relative: at(value + relative);
			default: at(value);
		}
	}

	inline function set(value:Float, address:Float, mode:Mode) {
		switch (mode) {
			case Immediate:
				throw 'no!';
			case Position:
				write(value, address);
			case Relative:
				write(value, address + relative);
		}
	}

	public inline function at(address:Float) {
		while (memory.length < address + 1) {
			memory.push(0);
		}
		return memory[Std.int(address)];
	}

	public inline function out(value:Float) {
		output.push(value);
	}

	public function run() {
		while (!stopped) {
			step();
		}
	}

	public function feed(i:Int) {
		input.push(i);
	}

	public function waitOutput(count:Int = 1) {
		var length = output.length;
		while (!stopped && output.length != length + count) {
			step();
		}
		return output.length > length ? output[length] : null;
	}

	public function readOutput() {
		var r = output;
		output = [];
		return r;
	}

	public function step() {
		if (stopped) {
			return;
		}

		var opcode = nextOpCode();
		switch (opcode.code) {
			case Add:
				final a = get(next(), opcode.modes[0]);
				final b = get(next(), opcode.modes[1]);
				set(a + b, next(), opcode.modes[2]);
			case Multiply:
				final a = get(next(), opcode.modes[0]);
				final b = get(next(), opcode.modes[1]);
				set(a * b, next(), opcode.modes[2]);
			case Input:
				set(input.shift(), next(), opcode.modes[0]);
			case Output:
				final a = get(next(), opcode.modes[0]);
				out(a);
			case JumpIfTrue:
				final a = get(next(), opcode.modes[0]);
				if (a > 0) {
					pc = Std.int(get(next(), opcode.modes[1]));
				} else {
					pc++;
				}
			case JumpIfFalse:
				final a = get(next(), opcode.modes[0]);
				if (a == 0) {
					pc = Std.int(get(next(), opcode.modes[1]));
				} else {
					pc++;
				}
			case LessThan:
				final a = get(next(), opcode.modes[0]);
				final b = get(next(), opcode.modes[1]);
				set(a < b ? 1 : 0, next(), opcode.modes[2]);
			case Equals:
				final a = get(next(), opcode.modes[0]);
				final b = get(next(), opcode.modes[1]);
				set(a == b ? 1 : 0, next(), opcode.modes[2]);
			case RBase:
				relative += get(next(), opcode.modes[0]);
			case Halt:
				halt();
			case Invalid:
				trace('Invalid opcode ${at(pc)} at address ${pc}');
				halt();
		}
	}
}
