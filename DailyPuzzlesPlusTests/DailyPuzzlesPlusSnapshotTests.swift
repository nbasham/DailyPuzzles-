import XCTest
@testable import DailyPuzzlesPlus
import SnapshotTesting

/*
 TO Run
    - On line 12 switch to XCTSkipIf(false)
    - Set device to iPhone 14 (17.0)
 */
final class DailyPuzzlesPlusSnapshotTests: XCTestCase {

    override func setUpWithError() throws {
        try XCTSkipIf(false)
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
        assertSnapshot(matching: MenuView_Previews.menu, as: .image, named: "menu")
        assertSnapshot(matching: MenuView_Previews.menuDisabled, as: .image, named: "menuDisabled")
    }

    func testMainMenu() throws {
        assertSnapshot(matching: MainMenuView_Previews.mainMenu, as: .image, named: "mainMenu")
        assertSnapshot(matching: MainMenuView_Previews.mainMenuDisabled, as: .image, named: "mainMenuDisabled")
    }

    func testGameMenu() throws {
        assertSnapshot(matching: GameMenuView_Previews.noTimer, as: .image, named: "noTimer")
        assertSnapshot(matching: GameMenuView_Previews.noTimerDisabled, as: .image, named: "noTimerDisabled")
        assertSnapshot(matching: GameMenuView_Previews.timerZeroSecs, as: .image, named: "timerZeroSecs")
        assertSnapshot(matching: GameMenuView_Previews.timerOneMinute, as: .image, named: "timerOneMinute")
        assertSnapshot(matching: GameMenuView_Previews.timerOneMinuteDisabled, as: .image, named: "timerOneMinuteDisabled")
    }

    func testMenuItem() throws {
        assertSnapshot(matching: MenuItemView_Previews.help, as: .image, named: "help")
        assertSnapshot(matching: MenuItemView_Previews.helpDisabled, as: .image, named: "helpDisabled")
    }
/*
    func testMemoryCard() throws {
        assertSnapshot(matching: MemoryView_Previews.easy, as: .image, named: "MemoryView_easy")
        assertSnapshot(matching: MemoryView_Previews.medium, as: .image, named: "MemoryView_medium")
        assertSnapshot(matching: MemoryView_Previews.hard, as: .image, named: "MemoryView_hard")
        assertSnapshot(matching: MemoryView_Previews.easyLandscape, as: .image, named: "MemoryView_easy-landscape")
        assertSnapshot(matching: MemoryView_Previews.mediumLandscape, as: .image, named: "MemoryView_medium-landscape")
        assertSnapshot(matching: MemoryView_Previews.hardLandscape, as: .image, named: "MemoryView_hard-landscape")
    }
 */
}
