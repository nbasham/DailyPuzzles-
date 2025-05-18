import SwiftUI

struct GameLauncherRowView: View {
    var game: GameDescriptor
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 0) {
            Text(game.displayName)
                .frame(maxWidth: 200, alignment: .trailing)
                .tint(.primary)
                .font(.system(size: UIDevice.isPhone ? 18 : 22, weight: .semibold))
                .frame(width: UIDevice.isPhone ? 152 : 256)
            //Spacer()
            MainBallView(game: game)
                .padding(.leading, isSelected ? 0 : 16)
                .frame(maxHeight: UIDevice.isPhone ? 34 : 54)
            Spacer()
        }
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isSelected ? Color.blue.opacity(0.2) : Color.clear)
        )
//        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
    }
}

#Preview {
    GameLauncherRowView(game: .memory, isSelected: false)
}

