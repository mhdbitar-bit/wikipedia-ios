import XCTest
import Utilities

final class UtilitiesTests: XCTestCase {
    func testExample() throws {
        let simpleArray = [0,1,2,3]
        XCTAssertEqual(simpleArray[safeIndex: 3], 3)
        XCTAssertNil(simpleArray[safeIndex: 4])
    }
}
