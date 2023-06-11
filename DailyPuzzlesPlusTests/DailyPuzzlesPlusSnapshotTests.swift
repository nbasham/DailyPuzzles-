import XCTest
@testable import DailyPuzzlesPlus
import SnapshotTesting

final class DailyPuzzlesPlusSnapshotTests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
        // we don't want to run this on Xcode Cloud as snapshots don't currently work and we want to be able to test multiple device types
        let isCI = ProcessInfo.processInfo.environment["CI"] == "TRUE"
        try XCTSkipIf(isCI)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
            let view = MainBallView(game: .memory)
            assertSnapshot(matching: view, as: .image)
    }
}
