import SwiftUI

struct MainView: View {
    @EnvironmentObject private var navigator: Navigator

    var body: some View {
        ZStack {
            Color("background")
                .ignoresSafeArea()
            VStack {
                ForEach(GameDescriptor.all) { game in
                    NavigationLink(game.displayName, value: game)
//                    Button(game.displayName) {
//                        navigator.push(game)
//                    }
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .gameHelp)) { _ in
            navigator.push("help")
        }
        .navigationDestination(for: GameDescriptor.self) { game in
            GameHostView(viewModel: GameHostViewModel(game: game))
        }
        .navigationDestination(for: String.self) { _ in
            ColorView(.yellow)
                .navigationTitle("Help")
        }
        .navigationBarTitle("") // hides Back on game screen
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color("top"), for: .navigationBar)
        .toolbar { MainToolbarView() }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(Navigator())
    }
}
