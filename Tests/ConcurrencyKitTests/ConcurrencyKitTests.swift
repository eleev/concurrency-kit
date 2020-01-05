import XCTest
@testable import ConcurrencyKit

final class ConcurrencyKitTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(ConcurrencyKit().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
