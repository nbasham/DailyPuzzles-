import XCTest
@testable import DailyPuzzlesPlus

final class DailyPuzzlesPlusTests: XCTestCase {

    let lines = [
        "Line 1",
        "Line 2",
        "Line 3",
        "Line 4"
    ]

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testExample() throws {
        AppSupportFile.save(lines, fileName: "test.txt")
        let readLines = AppSupportFile.load("test.txt") as? [String]
        XCTAssertEqual(lines, readLines)
        XCTAssertEqual("Line 1", readLines![0])
    }
}
