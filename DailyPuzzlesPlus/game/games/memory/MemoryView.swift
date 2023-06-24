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

struct MemoryView: View {
    @EnvironmentObject private var navigator: Navigator
    @StateObject var viewModel: MemoryViewModel
    @Environment(\.portraitDefault) var portraitDefault
    var isPortrait: Bool { portraitDefault.wrappedValue }
    let isPhone = UIDevice.current.userInterfaceIdiom == .phone

    func image(_ name: String) -> Image {
        let imageType = MemorySettings.imageType
        switch imageType {
            case .clipArt:
                return Image(uiImage: UIImage(named: name)!)
            case .emoji:
                return name.toImage()
            case .symbol:
                return Image(systemName: name)
        }
    }

    var body: some View {
        VStack {
            GeometryReader { proxy in
                LazyVGrid(columns: Array(repeating: .init(), count: viewModel.puzzle.numCols), spacing: viewModel.spacing) {
                    ForEach(0..<viewModel.puzzle.numCards, id: \.self) { index in
                        MemoryCardView(index: index, image: image(viewModel.puzzle[index]), found: viewModel.found[index])
                            .environmentObject(viewModel)
                            .aspectRatio(isPhone ? viewModel.cardAspectRatio : 1, contentMode: .fit)
                            .frame(width: viewModel.cardWidth)
                            .frame(height: viewModel.cardHeight)
                    }
                }
                .onChange(of: proxy.size) { size in
                    withAnimation {
                        viewModel.update(size: size)
                    }
                }
                .onAppear {
                    viewModel.start(size: proxy.size)
                }
            }
            .padding()
        }
    }
}

struct Card: Identifiable {
    let id: Int

    static func aspectRatio(isPortrait: Bool) -> CGFloat {
        isPortrait ? 64 / 94 :  94 / 64
    }

    static func spacing(level: GameLevel, isPortrait: Bool) -> CGFloat {
        let isPhone = UIDevice.current.userInterfaceIdiom == .phone
        switch level {
            case .easy:
                return isPhone ? 12 : (isPortrait ? 24 : 12)
            case .medium:
                return isPhone ? 16 : 16
            case .hard:
                return isPhone ? 12 : 12
        }
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

    static func sample(level: GameLevel) -> [Card] {
        switch level {
            case .easy:
                return sampleEasy
            case .medium:
                return sampleMedium
            case .hard:
                return sampleHard
        }
    }
    static var sampleEasy: [Card] {
        (0..<12).map { Card(id: $0) }
    }
    static var sampleMedium: [Card] {
        (0..<24).map { Card(id: $0) }
    }
    static var sampleHard: [Card] {
        (0..<40).map { Card(id: $0) }
    }
}
struct MemoryView_Previews: PreviewProvider {
    static var previews: some View {
        let host = GameHostView(viewModel: GameHostViewModel(game: .memory))
        @State var vm = MemoryViewModel(host: host, size: CGSize(width: 300, height: 600), level: .medium)
        GeometryReader { proxy in
            MemoryView(viewModel: vm)
                .onAppear {
                    vm.start(size: proxy.size)
                    vm.update(size: proxy.size)
                }
                .previewDisplayName("iPhone 14")
        }
    }
}
