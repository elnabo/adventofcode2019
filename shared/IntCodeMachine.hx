package shared;

typedef OpCode = {code:Code, modes:Array<Mode>};

enum abstract Mode(Int) from Int to Int {
	var Position = 0;
	var Immediate = 1;
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
	Halt;
	Invalid;
}

class IntCodeMachine {
	final memory:Array<Int>;
	final input:Int;
	var pc:Int = 0;
	var stopped = false;

	public var output = [];

	public function new(memory:Array<Int>, input:Int = 0) {
		this.memory = memory;
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

	inline function write(value:Int, address:Int) {
		memory[address] = value;
	}

	inline function halt() {
		stopped = true;
	}

	inline function get(value:Int, mode:Mode):Int {
		return switch (mode) {
			case Immediate: value;
			default: at(value);
		}
	}

	public inline function at(address:Int):Int {
		return memory[address];
	}

	public inline function out(value:Int) {
		output.push(value);
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

		var opcode = nextOpCode();
		switch (opcode.code) {
			case Add:
				final a:Int = get(next(), opcode.modes[0]);
				final b:Int = get(next(), opcode.modes[1]);
				final c:Int = next();
				write(a + b, c);
			case Multiply:
				final a:Int = get(next(), opcode.modes[0]);
				final b:Int = get(next(), opcode.modes[1]);
				final c:Int = next();
				write(a * b, c);
			case Input:
				final a = next();
				write(input, a);
			case Output:
				final a = get(next(), opcode.modes[0]);
				out(a);
			case JumpIfTrue:
				final a = get(next(), opcode.modes[0]);
				if (a > 0) {
					pc = get(next(), opcode.modes[1]);
				} else {
					pc++;
				}
			case JumpIfFalse:
				final a = get(next(), opcode.modes[0]);
				if (a == 0) {
					pc = get(next(), opcode.modes[1]);
				} else {
					pc++;
				}
			case LessThan:
				final a:Int = get(next(), opcode.modes[0]);
				final b:Int = get(next(), opcode.modes[1]);
				final c:Int = next();
				write(a < b ? 1 : 0, c);
			case Equals:
				final a:Int = get(next(), opcode.modes[0]);
				final b:Int = get(next(), opcode.modes[1]);
				final c:Int = next();
				write(a == b ? 1 : 0, c);
			case Halt:
				halt();
			case Invalid:
				trace('Invalid opcode ${at(pc)} at address ${pc}');
				halt();
		}
	}
}
