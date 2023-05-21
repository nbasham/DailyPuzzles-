import SwiftUI

struct MainView: View {
    @EnvironmentObject private var navigator: Navigator
    @EnvironmentObject private var play: Play

    var body: some View {
        ZStack {
            Color("background")
                .ignoresSafeArea()
            VStack {
                ForEach(GameDescriptor.all) { game in
                    NavigationLink(game.displayName, value: game)
                        .onTapGesture {
                            play.tap()
                        }
//                    Button(game.displayName) {
//                        navigator.push(game)
//                    }
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .gameHelp)) { _ in
            navigator.push("help")
        }
        .onReceive(NotificationCenter.default.publisher(for: .settings)) { _ in
            navigator.push("settings")
        }
        .navigationDestination(for: GameDescriptor.self) { game in
            GameHostView(viewModel: GameHostViewModel(game: game))
        }
        .navigationDestination(for: String.self) { path in
            if path == "settings" {
                SettingsView()
            } else {
                ColorView(.yellow)
                    .navigationTitle("Help")
            }
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
            .environmentObject(Play())
    }
}
