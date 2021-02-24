    import XCTest
    @testable import Narsil

    final class NarsilTests: XCTestCase {
        func testExample() {
            // This is an example of a functional test case.
            // Use XCTAssert and related functions to verify your tests produce the correct
            // results.
            var generator = Narsil()
            generator.generate()
        }
    }
