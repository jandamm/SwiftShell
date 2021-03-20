import Foundation

public func command(
	_ executable: Executable,
	_ arguments: String...,
	environment: [String: String]? = nil,
	currentDirectory: URL? = nil
) -> Command {
	Command(executable: executable, arguments: arguments, environment: environment, currentDirectory: currentDirectory)
}

public struct Command {
	private static let url: URL = .init(fileURLWithPath: "/usr/bin/env")

	let executable: Executable
	public var arguments: [String]
	public var environment: [String: String]?
	public var currentDirectory: URL?

	private func createProcess() -> Process {
		let process = Process()
		process.executableURL = Command.url
		process.arguments = [executable.name] + arguments
		process.environment = environment ?? process.environment
		process.currentDirectoryURL = currentDirectory ?? process.currentDirectoryURL
		return process
	}

	@discardableResult
	func execute(withIO pipes: IOPipe) throws -> Process {
		let process = createProcess()
		process.standardInput = pipes.input
		process.standardOutput = pipes.output
		try process.run()
		return process
	}
}

public extension Command {
	init(
		_ executable: Executable,
		_ arguments: String...,
		environment: [String: String]? = nil,
		currentDirectory: URL? = nil
	) {
		self.init(executable: executable, arguments: arguments, environment: environment, currentDirectory: currentDirectory)
	}
}

extension Command: Pipeable {
	public func pipe(to next: Command) -> PipedCommand {
		PipedCommand(initial: self, next: next)
	}
}

extension Command: Runable {
	public func run() throws {
		try execute(withIO: .none)
			.waitUntilExit()
	}
}
