import SwiftUI

class MemoryPuzzle: ObservableObject {
    @Published var numRows: Int
    @Published var numCols: Int
    var numCards: Int { numCols * numRows }
    let imageNames: [String]
    let indexes: [Int]
    let level: GameLevel
//    static private let allImageNames = Data.toString("memoryImageFileNames.txt")!.toLines
    static private let allImageNames = Data.toString("memorySymbolNames.txt")!.toLines

    subscript(index: Int) -> String {
        return imageNames[index] // ?? Image(systemName: "photo.fill")
    }

    init(id: String, puzzleString: String, level: GameLevel) {
        self.level = level
        indexes = puzzleString.components(separatedBy: ",").map { Int($0)!}
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
                        MemoryCardView(index: index, imageName: viewModel.puzzle[index], found: viewModel.found[index])
                            .environmentObject(viewModel)
                            .aspectRatio(isPad ? 1 : viewModel.cardAspectRatio, contentMode: .fit)
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
    let index: Int
    let imageName: String
    let found: Bool
    @State var isFlipped = false
    let durationAndDelay : CGFloat = 0.18
    @State private var rotation = 0.0

    func rotateCard() {
        withAnimation(.linear(duration: 0.75).delay(durationAndDelay)){
            rotation = 360
            print("rotating")
        }
    }

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
            FrontView(imageName: imageName, degree: $frontDegree, found: found)
                .rotationEffect(Angle(degrees: rotation))
            BackView(degree: $backDegree)
        }
        .onReceive(NotificationCenter.default.publisher(for: .flipCard)) { notification in
            if let info = notification.object as? [String:Int] {
                if let i = info["index"] {
                    if i == index {
                        flipCard()
                    }
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .rotateCard)) { notification in
            if let info = notification.object as? [String:Int] {
                if let i = info["index"] {
                    if i == index {
                        rotateCard()
                    }
                }
            }
        }
        .onTapGesture {
//            flipCard ()
            viewModel.cardTap(index: index)
        }
    }


    struct FrontView : View {
        let imageName: String
        @Binding var degree : Double
        let found: Bool

        var body: some View {
            ZStack {

                RoundedRectangle(cornerRadius: 7)
                    .strokeBorder(GameDescriptor.memory.color, lineWidth: found ? 0 : 5)
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
