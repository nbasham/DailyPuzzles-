import XCTest
import SwiftUI
@testable import DailyPuzzlesPlus

final class GameDescriptorTests: XCTestCase {

    func testDisplayName() {
        let expectedNames: [GameDescriptor: String] = [
            .cryptogram: "Cryptogram",
            .crypto_families: "Crypto-Families",
            .quotefalls: "Quotefalls",
            .sudoku: "Sudoku",
            .word_search: "Word Search",
            .memory: "Memory",
            .triplets: "Triplets",
            .sample_game: "Sample Game"
        ]

        for (descriptor, expectedName) in expectedNames {
            XCTAssertEqual(descriptor.displayName, expectedName, "\(descriptor) displayName is incorrect.")
        }
    }

    func testColorMapping() {
        let expectedColors: [GameDescriptor: Color] = [
            .cryptogram: .red,
            .crypto_families: .yellow,
            .quotefalls: .green,
            .sudoku: .blue,
            .word_search: .pink,
            .memory: .purple,
            .triplets: .orange,
            .sample_game: .cyan
        ]

        for (descriptor, expectedColor) in expectedColors {
            XCTAssertEqual(descriptor.color, expectedColor, "\(descriptor) color is incorrect.")
        }
    }

    func testAppUrl() {
        for descriptor in GameDescriptor.all {
            XCTAssertNotNil(descriptor.appUrl, "\(descriptor) appUrl should not be nil.")
            XCTAssertTrue(descriptor.appUrl?.absoluteString.contains("com.blacklabs") ?? false, "\(descriptor) appUrl does not contain expected scheme.")
        }
    }

    func testAppStoreUrl() {
        for descriptor in GameDescriptor.all {
            if descriptor != .sample_game { // Assuming sample_game has no store link
                XCTAssertNotNil(descriptor.appStoreUrl, "\(descriptor) appStoreUrl should not be nil.")
                XCTAssertTrue(descriptor.appStoreUrl?.absoluteString.contains("https://itunes.apple.com") ?? false, "\(descriptor) appStoreUrl is incorrect.")
            }
        }
    }

    func testHasLevels() {
        let expectedLevels: [GameDescriptor: Bool] = [
            .cryptogram: false,
            .crypto_families: false,
            .quotefalls: false,
            .sudoku: true,
            .word_search: true,
            .memory: true,
            .triplets: true,
            .sample_game: false
        ]

        for (descriptor, expectedLevel) in expectedLevels {
            XCTAssertEqual(descriptor.hasLevels, expectedLevel, "\(descriptor) hasLevels is incorrect.")
        }
    }

    func testStoreLinkImplementation() {
        for descriptor in GameDescriptor.all {
            if descriptor != .sample_game {
                XCTAssertNoThrow({
                    _ = descriptor.storeLink
                }, "\(descriptor) should not throw an error for storeLink.")
            }
        }
    }
}
