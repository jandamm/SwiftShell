import XCTest
@testable import swift_shell

final class swift_shellTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(swift_shell().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
