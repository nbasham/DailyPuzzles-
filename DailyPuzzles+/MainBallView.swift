import SwiftUI

struct MainBallView: View {
    let game: GameDescriptor
    @State private var isCompleted = false
    @State private var animateBall = false
    @Environment(\.isPreview) var isPreview

    var body: some View {
        Circle()
            .fill(
                Gradient(colors: [game.color.lighter(componentDelta: 0.2), game.color.lighter(), game.color, game.color.darker(), game.color.darker(componentDelta: 0.3)])
            )
            .rotationEffect(Angle(degrees: -35))
            .overlay(
                ballFill
            )
            .aspectRatio(1, contentMode: .fit)
            .rotationEffect(.degrees(animateBall ? 5*360 : 0))
            .onTapGesture {
                withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                    animateBall.toggle()
                }
            }
            .onAppear {
                guard !isPreview else { return }
                isCompleted = DailyStorage.isCompleted(game: game)
            }
    }

    @ViewBuilder
    var ballFill: some View {
        if isCompleted {
            Image(systemName: "checkmark")
                .bold()
                .foregroundColor(.white)
        } else {
            Text("play")
                .minimumScaleFactor(0.2)
                .lineLimit(1)
                .fontWeight(.semibold)
                .font(.system(size: 13, design: .rounded))
                .foregroundColor(.white.opacity(0.8))
                .offset(y: -1)
                .padding(4) // pushes 'play' from circle edge
        }
    }
}

struct MainBallView_Previews: PreviewProvider {
    static var previews: some View {
        MainBallView(game: .sudoku)
            .frame(maxWidth: 64)
    }
}
