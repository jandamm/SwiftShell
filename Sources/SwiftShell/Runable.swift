public protocol Runable {
	func run() throws
}

public func run(_ runable: Runable) throws {
	try runable.run()
}
