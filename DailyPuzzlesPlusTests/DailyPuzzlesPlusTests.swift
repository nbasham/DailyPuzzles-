import XCTest
@testable import DailyPuzzlesPlus

final class DailyPuzzlesPlusTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
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
