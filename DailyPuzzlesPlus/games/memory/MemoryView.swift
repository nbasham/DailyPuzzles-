//
//  MemoryView.swift
//  DailyPuzzlesPlus
//
//  Created by Norman Basham on 5/31/23.
//

import SwiftUI

enum Level: Int {
    case easy = 1, medium = 2, hard = 3
}

@MainActor
class MemoryViewModel: ObservableObject {
    let host: GameHost
    let level: Level
    let cards: [Card]
    @Published var numCols = 0
    @Published var numRows = 0
    @Published var spacing: CGFloat = 12
    @Published var cardWidth: CGFloat = 4
    @Published var cardHeight: CGFloat = 4
    @Published var cardAspectRatio: CGFloat = 64 / 94

    init(host: GameHost, size: CGSize, level: Level = .easy) {
        self.host = host
        self.level = level
        cards = Card.sample(level: level)
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
        print(cardAspectRatio)
        numCols = Card.numCols(level: level, isPortrait: isPortrait)
        numRows = Card.numRows(level: level, isPortrait: isPortrait)
        cardWidth = (size.width - CGFloat(numCols-1)*CGFloat(spacing/2)) / CGFloat(numCols) - 1
        cardWidth = max(0, cardWidth)
        cardHeight = (size.height - CGFloat(numRows+1)*CGFloat(spacing)) / CGFloat(numRows) - 1
        cardHeight = max(0, cardHeight)
    }
}

struct MemoryView: View {
    @ObservedObject var viewModel: MemoryViewModel
    @Environment(\.portraitDefault) var portraitDefault
    var isPortrait: Bool { portraitDefault.wrappedValue }

    var body: some View {
        VStack {
            GeometryReader { proxy in
                LazyVGrid(columns: Array(repeating: .init(), count: viewModel.numCols), spacing: viewModel.spacing) {
                    ForEach(viewModel.cards, id: \.id) { card in
                        MemoryCardView()
                            .environmentObject(viewModel)
                            .aspectRatio(viewModel.cardAspectRatio, contentMode: .fit)
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

    static func spacing(level: Level, isPortrait: Bool) -> CGFloat {
        switch level {
            case .easy:
                return 12
            case .medium:
                return 16
            case .hard:
                return 12
        }
    }

    static func numRows(level: Level, isPortrait: Bool) -> Int {
        switch level {
            case .easy:
                return isPortrait ? 4 : 3
            case .medium:
                return isPortrait ? 6 : 4
            case .hard:
                return isPortrait ? 8 : 5
        }
    }

    static func numCols(level: Level, isPortrait: Bool) -> Int {
        switch level {
            case .easy:
                return isPortrait ? 3 : 4
            case .medium:
                return isPortrait ? 4 : 6
            case .hard:
                return isPortrait ? 5 : 8
        }
    }

    static func sample(level: Level) -> [Card] {
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
        NavigationStack {
            GeometryReader { proxy in
                MemoryView(viewModel: MemoryViewModel(host: GameHostView(viewModel: GameHostViewModel(game: .memory)), size: CGSize(width: 100, height: 100)))
                    .padding()
                    .padding(.top)
            }
        }
    }
}


struct MemoryCardView: View {
    @EnvironmentObject var viewModel: MemoryViewModel
    @State var backDegree = 0.0
    @State var frontDegree = -90.0
    @State var isFlipped = false
    let durationAndDelay : CGFloat = 0.3

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
            FrontView(degree: $frontDegree)
            BackView(degree: $backDegree)
        }
        .onTapGesture {
            viewModel.playAlreadySelected()
            flipCard ()
        }
    }


    struct FrontView : View {
        @Binding var degree : Double

        var body: some View {
            ZStack {

                RoundedRectangle(cornerRadius: 7)
                    .strokeBorder(GameDescriptor.memory.color, lineWidth: 5)
                    .background(RoundedRectangle(cornerRadius: 7)
.fill(Color(uiColor: UIColor.secondarySystemGroupedBackground)))

                Image(systemName: "suit.club.fill")
                    .resizable()
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
