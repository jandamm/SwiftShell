public struct Executable {
	let name: String
}

extension Executable: ExpressibleByStringLiteral {
	public typealias StringLiteralType = String

	public init(stringLiteral name: String) {
		self.init(name: name)
	}
}

public extension Executable {
	// TODO: Add more executables
	static let echo: Executable = "echo"
	static let mkdir: Executable = "mkdir"
	static let pbcopy: Executable = "pbcopy"
}
