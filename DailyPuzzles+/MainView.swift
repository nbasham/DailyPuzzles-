import SwiftUI

struct MainView: View {
    @EnvironmentObject private var navigator: Navigator
    @EnvironmentObject private var play: Play

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color("background")
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 16) {
                ForEach(GameDescriptor.all) { game in
                    HStack {
                        Circle()
                            .fill(
                                game.color
                            )
                            .frame(height: 25)
                            .aspectRatio(1, contentMode: .fit)
                       NavigationLink(game.displayName, value: game)
                            .tint(.primary)
                         Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                        .onTapGesture {
                            play.tap()
                        }
//                    Button(game.displayName) {
//                        navigator.push(game)
//                    }
                }
            }
            .padding()
            .padding(.horizontal)
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
