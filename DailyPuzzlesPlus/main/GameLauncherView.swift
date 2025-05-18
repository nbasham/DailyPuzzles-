import SwiftUI

struct GameLauncherView: View {
    var gameDescriptors: [GameDescriptor] = [] // Replace or inject as needed
    @State private var selected: GameDescriptor?

    var body: some View {
        GeometryReader { geometry in
            let isPortrait = geometry.size.height > geometry.size.width
            let isPad = UIDevice.current.userInterfaceIdiom == .pad
            let rowHeight: CGFloat = {
                if isPad {
                    return isPortrait ? 72 : 64
                } else {
                    return isPortrait ? 54 : 34
                }
            }()

            let requiredListSpacing = CGFloat(gameDescriptors.count) * 8
            let maxRowHeight = (geometry.size.height - requiredListSpacing) / CGFloat(gameDescriptors.count)
            let calculatedRowHeight: CGFloat = {
                guard geometry.size.height > 0 else { return rowHeight }
                return min(rowHeight, maxRowHeight)
            }()
//            let finalRowHeight = min(rowHeight, maxRowHeight)

            VStack(alignment: .leading, spacing: 8) {
                ForEach(gameDescriptors) { game in
                    GameLauncherRowView(game: game, isSelected: game == selected)
                        .contentShape(Rectangle())
                        .frame(height: calculatedRowHeight)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                selected = game
                            }
                            onSelect(game)
                        }
                }
            }
            .padding(.top, 8)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
    }

    func onSelect(_ game: GameDescriptor) {
        Play.tap()
        /*
         withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
         animateBall.toggle()
         }
         */
    }
}

#Preview {
    VStack {
        Color.brown
            .frame(height: 80)
        GameLauncherView(gameDescriptors: Settings.onAndOrderedGames())
//        Color.brown
//            .frame(height: 140)
        MainBottomView()
    }
    .ignoresSafeArea()
}

struct MainBottomView: View {
    @Environment(\.safeAreaDefault) var safeAreaDefault
    var safeAreaInsets: EdgeInsets { safeAreaDefault.wrappedValue }
    let message: LocalizedStringKey = "On this day in 1946, the Bikini is introduced. French designer Louis Reard unveils a daring two-piece swimsuit at the Piscine Molitor, a popular swimming pool in Paris."

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            Color.top.opacity(0.2)
                .ignoresSafeArea()
            HStack {
                Circle()
                    .foregroundColor(.top)
                    .position(y: 70)
                //                .frame(height: 140 - safeAreaInsets.bottom)
                //                .offset(x: -(88 + safeAreaInsets.bottom)/2)
                FactoidView(message: message)
                    .offset(x: -70 - 35)
            }
//            .padding(0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
        .frame(height: 140)
    }
}
