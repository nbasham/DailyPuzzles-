import SwiftUI

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

    static var easy: some View {
        wrapper(level: .easy, size: size)
    }

    static var easyLandscape: some View {
        wrapper(level: .easy, size: landscapeSize)
    }

    static var medium: some View {
        wrapper(level: .medium, size: size)
    }

    static var mediumLandscape: some View {
        wrapper(level: .medium, size: landscapeSize)
    }

    static var hard: some View {
        wrapper(level: .hard, size: size)
    }

    static var hardLandscape: some View {
        wrapper(level: .hard, size: landscapeSize)
    }

    static func wrapper(level: GameLevel, size: CGSize = CGSize(width: 390.0, height: 763.0), imageType: MemorySettings.ImageType = .clipArt) -> some View {
        let host = GameHostView(viewModel: GameHostViewModel(game: .memory))
        @State var vm = MemoryViewModel(host: host, size: size, level: level, debugPreview: true)
        MemorySettings.imageType = imageType
        return MemoryView(viewModel: vm)
            .onAppear { vm.update(size: size) }
            .frame(width: size.width, height: size.height)
    }

    static let size = CGSize(width: 390.0, height: 763.0)
    static let landscapeSize = CGSize(width: 763.0, height: 330.0)
    static var previews: some View {
        easy
            .previewDisplayName("easy")
            .previewInterfaceOrientation(.portrait)
            .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
        easy
            .previewDisplayName("easy dark")
            .previewInterfaceOrientation(.portrait)
            .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
            .preferredColorScheme(.dark)
        medium
            .previewDisplayName("medium")
            .previewInterfaceOrientation(.portrait)
        hard
            .previewDisplayName("hard")
            .previewInterfaceOrientation(.portrait)
        easyLandscape
            .previewInterfaceOrientation(.landscapeRight)
            .previewDisplayName("easy-landscape")
        mediumLandscape
            .previewDisplayName("medium-landscape")
            .previewInterfaceOrientation(.landscapeLeft)
        hardLandscape
            .previewDisplayName("hard-landscape")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
