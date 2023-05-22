import SwiftUI

/*
 Todo figure out how to broadcast rotation changes
 */
struct MainView: View {
    @EnvironmentObject private var navigator: Navigator
    @EnvironmentObject private var play: Play
    @State private var coverScreen: FullCoverPath?

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color("background")
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 0) {
                GeometryReader { proxy in
                    ZStack {
                        Color.yellow
                        Text(proxy.size.description)
                    }
                }
//                gameChooserView
                Spacer()
                FactoidView()
                    .frame(height: 88)
                    .ignoresSafeArea(edges: .bottom)
            }
//            .padding()
//            .padding(.horizontal)
        }
        .onAppear {
            DailyStorage.isNewDay()
        }
        .onReceive(NotificationCenter.default.publisher(for: .help)) { value in
            coverScreen = FullCoverPath(value: "help")
        }
        .onReceive(NotificationCenter.default.publisher(for: .contact)) { value in
            coverScreen = FullCoverPath(value: "contact")
        }
        .onReceive(NotificationCenter.default.publisher(for: .settings)) { _ in
            navigator.push("settings")
        }
        .navigationDestination(for: GameDescriptor.self) { game in
            GameHostView(viewModel: GameHostViewModel(game: game))
        }
        .fullScreenCover(item: $coverScreen) { path in
            if path.description == "help" {
                MainHelpView()
            } else if path.description == "contact" {
                EmailView()
            } else {
                ColorView(.orange)
            }
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

    private var gameChooserView: some View {
        ForEach(GameDescriptor.all) { game in
            HStack {
                MainBallView(game: game)
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
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(Navigator())
            .environmentObject(Play())
    }
}
