import SwiftUI

struct CryptogramView: View {
    let host: GameHost
    let size: CGSize

    var body: some View {
        ZStack {
            host.game.color.opacity(0.3)
            VStack {
                Text(size.debugDescription)
                Button("Solve") {
                    host.didSolve()
                }
            }
        }
    }
}

struct CryptogramView_Previews: PreviewProvider {
    static var previews: some View {
        CryptogramView(host: GameHostView(viewModel: GameHostViewModel(game: .quotefalls)), size: CGSize(width: 100, height: 100))
            .environmentObject(Coordinator())
    }
}
