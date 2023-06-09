import XCTest
@testable import DailyPuzzlesPlus
import SnapshotTesting

final class DailyPuzzlesPlusTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testSnapshots() {
        let view = MainBallView(game: .memory)
        assertSnapshot(matching: view, as: .image)
    }

    func testMemoryImages() throws {
        let allImageNames = Data.toString("memoryImageFileNames.txt")!.toLines
        for imageName in allImageNames {
            if imageName.isEmpty { continue }
//            XCTAssertNotNil(UIImage(named: imageName))
            if(UIImage(named: imageName) == nil) {
                print("--------------------------\(imageName)")
            }
        }
    }
}
