import SwiftUI

class MemoryPuzzle: ObservableObject {
    @Published var numRows: Int
    @Published var numCols: Int
    var numCards: Int { numCols * numRows }
    let imageNames: [String]
    let indexes: [Int]
    let level: GameLevel

    subscript(index: Int) -> String {
        return imageNames[index]
    }

    static private func imageNames() -> [String] {
        let imageType = MemorySettings.imageType
        switch imageType {
            case .clipArt:
                return Data.toString("memoryImageFileNames.txt")!.toLines
            case .emoji:
                return Data.toString("emojiList.txt")!.toLines
            case .symbol:
                return Data.toString("memorySymbolNames.txt")!.toLines
        }
    }

    init(id: String, puzzleString: String, level: GameLevel) {
        self.level = level
        indexes = puzzleString.components(separatedBy: ",").map { Int($0)!}
        let allImageNames = MemoryPuzzle.imageNames()
        imageNames = indexes.map { allImageNames[$0] }
        numRows = MemoryPuzzle.numRows(level: level, isPortrait: UIDevice.current.orientation == .portrait)
        numCols = MemoryPuzzle.numCols(level: level, isPortrait: UIDevice.current.orientation == .portrait)
    }

    func update(isPortrait: Bool) {
        numRows = MemoryPuzzle.numRows(level: level, isPortrait: isPortrait)
        numCols = MemoryPuzzle.numCols(level: level, isPortrait: isPortrait)
    }

    static func numRows(level: GameLevel, isPortrait: Bool) -> Int {
        switch level {
            case .easy:
                return isPortrait ? 4 : 3
            case .medium:
                return isPortrait ? 6 : 4
            case .hard:
                return isPortrait ? 8 : 5
        }
    }

    static func numCols(level: GameLevel, isPortrait: Bool) -> Int {
        switch level {
            case .easy:
                return isPortrait ? 3 : 4
            case .medium:
                return isPortrait ? 4 : 6
            case .hard:
                return isPortrait ? 5 : 8
        }
    }
}

extension MemoryPuzzle {
    ///  Provides a consistent way to view puzzles in Preview
    static func samplePuzzle(forLevel level: GameLevel) -> MemoryPuzzle {
        switch level {
            case .easy:
                return .easy
            case .medium:
                return .medium
            case .hard:
                return .hard
        }
    }
    static let easy = MemoryPuzzle(id: "easy", puzzleString: "239,145,330,337,239,21,330,57,337,57,145,21", level: .easy)
    static let medium = MemoryPuzzle(id: "medium", puzzleString: "232,67,313,175,67,341,342,236,341,236,154,176,34,154,313,177,232,134,176,34,134,175,177,342", level: .medium)
    static let hard = MemoryPuzzle(id: "hard", puzzleString: "344,204,154,121,36,215,284,235,331,104,119,9,121,152,249,284,215,119,122,344,212,331,314,9,103,212,152,204,235,348,103,122,314,36,154,198,249,348,104,198", level: .hard)
}
