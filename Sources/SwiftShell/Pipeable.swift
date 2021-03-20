public protocol Pipeable {
	func pipe(to next: Command) -> PipedCommand
}

public func | (pipeable: Pipeable, next: Command) -> PipedCommand {
	pipeable.pipe(to: next)
}
