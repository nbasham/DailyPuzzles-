import SwiftUI

@MainActor
class MemoryViewModel: ObservableObject {
    @Published var selection1: Int?
    @Published var attempts = 0
    @Published var found: [Bool] = [Bool](repeating:false, count:0)
    var noSelections: Bool { return selection1 == nil }
    var hasSelection: Bool { return selection1 != nil }

    let host: GameHost
    let level: GameLevel
//    let cards: [Card]
    @Published var puzzle: MemoryPuzzle
    @Published var spacing: CGFloat = 12
    @Published var cardPadding: CGFloat = 2
    @Published var cardSelectionLen: CGFloat = 4
    @Published var cardWidth: CGFloat = 4
    @Published var cardHeight: CGFloat = 4
    @Published var cardAspectRatio: CGFloat = 64 / 94

    init(host: GameHost, size: CGSize, level: GameLevel) {
        self.host = host
        self.level = level
//        cards = Card.sample(level: level)
        puzzle = MemoryPuzzle(id: "id", puzzleString: "239,145,330,337,239,21,330,57,337,57,145,21", level: .easy)
        update(size: size)
        host.prepareSound(soundName: "AlreadySelected")
        found = [Bool](repeating:false, count: puzzle.numCards)
    }

    func start(size: CGSize) {
        let data = ContentService.memory(level: level)
        let items = data.split(separator: "\t")
        let id = String(items[0])
        let puzzleString = String(items[1])
        puzzle = MemoryPuzzle(id: id, puzzleString: puzzleString, level: level)
        print(puzzle.numCards)
        found = [Bool](repeating:false, count: puzzle.numCards)
    }

    func playAlreadySelected() {
        host.playSound(soundName: "AlreadySelected")
    }

    private func tapAction(index: Int) -> TapAction {
        if found[index] {
            return .tappedFound
        } else if index == selection1 {
            return .tappedCurrentSelection
        } else if noSelections {
            return .select(index)
        } else if hasSelection {
            guard let selection1Index = selection1 else { return .noAction }
            if indexesMatch(selection1Index, index) {
                return .correct(selection1Index, index)
            } else {
                return .incorrect(selection1Index, index)
            }
        }
        return .noAction
    }

    func cardTap(index: Int) {
        func flip(index: Int) {
            NotificationCenter.default.post(name: .flipCard, object: ["index": index])
        }
        func rotate(index: Int) {
            NotificationCenter.default.post(name: .rotateCard, object: ["index": index])
        }
        let action = tapAction(index: index)
        print(action)
        switch action {
            case .noAction:
                break
            case .tappedFound:
                playAlreadySelected()
            case .tappedCurrentSelection:
                host.playIncorrect()
            case .select(let index):
                selection1 = index
                flip(index: index)
                host.playCorrect()
            case let .correct(index1, index2):
                selection1 = nil
                flip(index: index)
                host.playCorrect()
                attempts += 1
                found[index1] = true
                found[index2] = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    rotate(index: index1)
                    rotate(index: index2)
                }
                if self.found.allSatisfy({ $0 == true }) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.75) {
                        self.host.didSolve()
                    }
                }
            case let .incorrect(index1, index2):
                selection1 = nil
                flip(index: index2)
                host.playIncorrect()
                attempts += 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.95) {
                    flip(index: index1)
                    flip(index: index2)
                }
                clearSelections()
        }
    }

    func update(size: CGSize) {
        let isPortrait = size.width < size.height
        cardAspectRatio = Card.aspectRatio(isPortrait: isPortrait)
        spacing = Card.spacing(level: level, isPortrait: isPortrait)
        puzzle.update(isPortrait: isPortrait)
        cardWidth = (size.width - CGFloat(puzzle.numCols-1)*CGFloat(spacing/2)) / CGFloat(puzzle.numCols) - 1
        cardWidth = max(0, cardWidth)
        cardHeight = (size.height - CGFloat(puzzle.numRows+1)*CGFloat(spacing)) / CGFloat(puzzle.numRows) - 1
        print("\(Int(cardWidth)) x \(Int(cardHeight))")
        cardHeight = max(0, cardHeight)
        cardPadding = calcPadding(cardWidth: cardWidth, cardHeight: cardHeight)
        cardSelectionLen = calcSelection(cardWidth: cardWidth, cardHeight: cardHeight)
    }

    private func calcPadding(cardWidth: CGFloat, cardHeight: CGFloat) -> CGFloat {
        if UIDevice.isPhone {
            cardPadding = min(2, cardPadding/33)
        }
        return 8
    }

    private func calcSelection(cardWidth: CGFloat, cardHeight: CGFloat) -> CGFloat {
        let minLen = min(cardWidth, cardHeight)
        if minLen > 160 { return 5 }
        else if minLen > 120 { return 4 }
        else if minLen > 80 { return 3 }
        else { return 2 }
    }
}

extension NSNotification.Name {
    static let flipCard = NSNotification.Name("flipCard")
    static let rotateCard = NSNotification.Name("rotateCard")
}

enum TapAction {
    case noAction, tappedFound, tappedCurrentSelection, select(Int), correct(Int, Int), incorrect(Int, Int)
}
extension MemoryViewModel {
    func restart() {
        clearFound()
        clearSelections()
        attempts = 0
    }

    func indexesMatch(_ i1 : Int, _ i2 : Int) -> Bool {
        return puzzle.indexes[i1] == puzzle.indexes[i2]
    }

    func isDirty() -> Bool {
        return attempts > 0
    }

    func solve() {
        found = [Bool](repeating:true, count: puzzle.numCards)
        clearSelections()
        host.didSolve()
    }

    func index(atIndex index : Int) -> Int {
        return puzzle.indexes[index]
    }

    func matchingIndex(forIndex index : Int) -> Int {
        for i in 0..<puzzle.numCards {
            if i == index { continue }
            if puzzle.indexes[index] == puzzle.indexes[i] {
                return i
            }
        }
        fatalError("There should always be a matching index.")

    }

    func isFoundAtIndex(_ index : Int) -> Bool {
        return found[index]
    }

    func incAttempts() { attempts += 1 }

    func clearFound() {
        found = [Bool](repeating:false, count: puzzle.numCards)
    }

    func clearSelections() {
        selection1 = nil
    }
}
