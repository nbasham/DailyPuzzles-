import SwiftUI

struct MainRowView: View {
    let game: GameDescriptor

    var body: some View {
        ZStack {
            Color.orange
            HStack {
                HStack {
                    Spacer()
                    NavigationLink(game.displayName, value: game)
                }
                .frame(maxWidth: 200)
                .tint(.primary)
                .font(.system(size: UIDevice.isPhone ? 18 : 22, weight: .semibold))
                .frame(width: UIDevice.isPhone ? 148 : 256)
                Spacer().frame(width: 16)
                MainBallView(game: game)
                    .frame(maxHeight: UIDevice.isPhone ? 34 : 54)
                Spacer()
            }
        }
    }
}

#Preview {
    MainRowView(game: .crypto_families)
}

struct RowView: View {
    let label: String

    var body: some View {
        HStack(spacing: 0) {
            // The text only uses as much width as it needs
            Text(label)
                .font(.system(size: 18))
                .fixedSize()                // Prevents the text from expanding
                .padding(.trailing, 24)     // Exactly 24px to circle’s leading edge

            // 20px-wide circle will occupy x = 180 to x = 200
            Circle()
                .fill(Color.blue)
                .frame(width: 20, height: 20)
        }
        // Constrain the total width to 200px, so the circle’s right edge is x = 200
        .frame(width: 200, alignment: .leading)
    }
}

struct RowsView: View {
    let items = ["Item 1", "Item 2", "Item 3"] // Replace with your data

    var body: some View {
        List(items, id: \.self) { item in
            RowView(label: item)
                .listRowSeparator(.hidden) // Removes separator lines
                .listRowBackground(Color.clear) // Removes row background
        }
        .scrollContentBackground(.hidden) // Hides the list's default background
        .background(Color.yellow) // Sets the desired background color
    }
}
#Preview {
    RowsView()
}
