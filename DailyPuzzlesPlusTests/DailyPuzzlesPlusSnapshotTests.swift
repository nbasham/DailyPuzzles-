import XCTest
@testable import DailyPuzzlesPlus
import SnapshotTesting

final class DailyPuzzlesPlusSnapshotTests: XCTestCase {

    override func setUpWithError() throws {
#if SKIP_SNAPSHOTS
        try XCTSkipIf(true)
#endif
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGameToolbar() throws {
        assertSnapshot(matching: GameToolbarView_Previews.notSolvedWithTimerAtZero, as: .image, named: "notSolvedWithTimerAtZero")
        assertSnapshot(matching: GameToolbarView_Previews.notSolvedWithTimerOneMinute, as: .image, named: "notSolvedWithTimerOneMinute")
        assertSnapshot(matching: GameToolbarView_Previews.notSolvedNoTimer, as: .image, named: "notSolvedNoTimer")
        assertSnapshot(matching: GameToolbarView_Previews.solvedWithTimerAtZero, as: .image, named: "solvedWithTimerAtZero")
        assertSnapshot(matching: GameToolbarView_Previews.solvedWithTimerOneMinute, as: .image, named: "solvedWithTimerOneMinute")
        assertSnapshot(matching: GameToolbarView_Previews.solvedNoTimer, as: .image, named: "solvedNoTimer")
    }

    func testMenu() throws {
        assertSnapshot(matching: MenuItemView_Previews.help, as: .image, named: "help")
        assertSnapshot(matching: MenuItemView_Previews.helpDisabled, as: .image, named: "helpDisabled")
    }
}
