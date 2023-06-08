import SwiftUI

class MemoryPuzzle: ObservableObject {
    @Published var numRows: Int
    @Published var numCols: Int
    var numCards: Int { numCols * numRows }
    let imageNames: [String]
    let level: GameLevel
//    static private let allImageNames = Data.toString("memoryImageFileNames.txt")!.toLines
    static private let allImageNames = Data.toString("memorySymbolNames.txt")!.toLines

    subscript(index: Int) -> String {
        return imageNames[index] // ?? Image(systemName: "photo.fill")
    }

    init(id: String, puzzleString: String, level: GameLevel) {
        self.level = level
        let indexes = puzzleString.components(separatedBy: ",").map { Int($0)!}
        imageNames = indexes.map { MemoryPuzzle.allImageNames[$0] }
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

@MainActor
class MemoryViewModel: ObservableObject {
    let host: GameHost
    let level: GameLevel
    let cards: [Card]
    @Published var puzzle: MemoryPuzzle
//    @Published var numRows = 0
    @Published var spacing: CGFloat = 12
    @Published var cardWidth: CGFloat = 4
    @Published var cardHeight: CGFloat = 4
    @Published var cardAspectRatio: CGFloat = 64 / 94

    init(host: GameHost, size: CGSize, level: GameLevel = .easy) {
        self.host = host
        self.level = level
        cards = Card.sample(level: level)
        puzzle = MemoryPuzzle(id: "id", puzzleString: "239,145,330,337,239,21,330,57,337,57,145,21", level: .easy)
        update(size: size)
        host.prepareSound(soundName: "AlreadySelected")
    }

    func playAlreadySelected() {
        host.playSound(soundName: "AlreadySelected")
    }

    func update(size: CGSize) {
        let isPortrait = size.width < size.height
        cardAspectRatio = Card.aspectRatio(isPortrait: isPortrait)
        spacing = Card.spacing(level: level, isPortrait: isPortrait)
        puzzle.update(isPortrait: isPortrait)
        cardWidth = (size.width - CGFloat(puzzle.numCols-1)*CGFloat(spacing/2)) / CGFloat(puzzle.numCols) - 1
        cardWidth = max(0, cardWidth)
        cardHeight = (size.height - CGFloat(puzzle.numRows+1)*CGFloat(spacing)) / CGFloat(puzzle.numRows) - 1
        cardHeight = max(0, cardHeight)
    }
}

struct MemoryView: View {
    @StateObject var viewModel: MemoryViewModel
    @Environment(\.portraitDefault) var portraitDefault
    var isPortrait: Bool { portraitDefault.wrappedValue }
    let isPad = UIDevice.current.userInterfaceIdiom == .pad

    var body: some View {
        VStack {
            GeometryReader { proxy in
                LazyVGrid(columns: Array(repeating: .init(), count: viewModel.puzzle.numCols), spacing: viewModel.spacing) {
                    ForEach(0..<viewModel.puzzle.numCards, id: \.self) { index in
                        MemoryCardView(imageName: viewModel.puzzle[index])
                            .environmentObject(viewModel)
                            .aspectRatio(isPad ? 1 : viewModel.cardAspectRatio, contentMode: .fit)
                            .frame(width: viewModel.cardWidth)
                            .frame(height: viewModel.cardHeight)
                    }
                }
                .onAppear {
                    viewModel.update(size: proxy.size)
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
        let isPad = UIDevice.current.userInterfaceIdiom == .pad
        switch level {
            case .easy:
                return isPad ? (isPortrait ? 24 : 12) : 12
            case .medium:
                return isPad ? 16 : 16
            case .hard:
                return isPad ? 12 : 12
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
        host.environmentObject(Play())
        host.environmentObject(Settings())
        Group {
            MemoryView(viewModel: MemoryViewModel(host: host, size: CGSize(width: 320, height: 500)))
                .environmentObject(Play())
                .environmentObject(Settings())
                .previewInterfaceOrientation(.portrait)
                .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
                .previewDisplayName("iPhone 14")

            MemoryView(viewModel: MemoryViewModel(host: host, size: CGSize(width: 500, height: 300)))
                .environmentObject(Play())
                .environmentObject(Settings())
                .previewInterfaceOrientation(.landscapeRight)
                .previewDisplayName("iPhone 14 landscape")
                .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
        }
    }
}

//  https://betterprogramming.pub/card-flip-animation-in-swiftui-45d8b8210a00
struct MemoryCardView: View {
    @EnvironmentObject var viewModel: MemoryViewModel
    @State var backDegree = 0.0
    @State var frontDegree = -90.0
    @State var isFlipped = false
    let imageName: String
    let durationAndDelay : CGFloat = 0.18

    func flipCard () {
        isFlipped = !isFlipped
        if isFlipped {
            withAnimation(.linear(duration: durationAndDelay)) {
                backDegree = 90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)){
                frontDegree = 0
            }
        } else {
            withAnimation(.linear(duration: durationAndDelay)) {
                frontDegree = -90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)){
                backDegree = 0
            }
        }
    }

    var body: some View {
        ZStack {
            FrontView(imageName: imageName, degree: $frontDegree)
            BackView(degree: $backDegree)
        }
        .onTapGesture {
            viewModel.playAlreadySelected()
            flipCard ()
        }
    }


    struct FrontView : View {
        let imageName: String
        @Binding var degree : Double

        var body: some View {
            ZStack {

                RoundedRectangle(cornerRadius: 7)
                    .strokeBorder(GameDescriptor.memory.color, lineWidth: 5)
                    .background(RoundedRectangle(cornerRadius: 7)
.fill(Color(uiColor: UIColor.secondarySystemGroupedBackground)))

//                Image(uiImage: UIImage(named: imageName)!)
                Image(systemName: imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(GameDescriptor.memory.color)
                    .padding()
            }
            .rotation3DEffect(Angle(degrees: degree), axis: (x: 0.001, y: 1, z: 0.001))
        }
    }

    struct BackView : View {
        @Binding var degree : Double

        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 7)
                    .strokeBorder(Color(uiColor: UIColor.systemGray3), lineWidth: 1)
                    .background(
                        ZStack {
                            RoundedRectangle(cornerRadius: 7)
                                .fill(Color(uiColor: UIColor.secondarySystemGroupedBackground))
                            Image("question-mark")
                                .resizable()
                                .aspectRatio(1, contentMode: .fit)
                                .foregroundColor(Color(uiColor: UIColor.systemGray3))
//                                .shadow(color: .black, radius: 1, x: 1, y: 1)
                                .padding()
                        }
                    )

            }
            .rotation3DEffect(Angle(degrees: degree), axis: (x: 0.001, y: 1, z: 0.001))

        }
    }
}
