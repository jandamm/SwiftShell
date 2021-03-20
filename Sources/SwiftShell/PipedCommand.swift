import Foundation

public struct PipedCommand {
	private var commands: [Command]
	private var lastCommand: Command {
		didSet { commands.append(oldValue) }
	}

	init(initial: Command, next: Command) {
		commands = [initial]
		lastCommand = next
	}
}

extension PipedCommand: Runable {
	public func run() throws {
		let pipes: IOPipe = try commands.reduce(.initial()) { pipes, command in
			try command.execute(withIO: pipes)
			return pipes.next()
		}
		try lastCommand.execute(withIO: pipes)
			.waitUntilExit()
	}
}

extension PipedCommand: Pipeable {
	public func pipe(to next: Command) -> PipedCommand {
		var pipe = self
		pipe.lastCommand = next
		return pipe
	}
}

struct IOPipe {
	let input: Pipe?
	let output: Pipe?

	func next() -> IOPipe {
		.init(input: output, output: Pipe())
	}

	static let none: IOPipe = .init(input: nil, output: nil)

	static func initial() -> IOPipe { .init(input: nil, output: Pipe()) }
}
