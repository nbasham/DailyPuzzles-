import SwiftUI

struct MainView: View {
    @EnvironmentObject private var coordinator: Coordinator

    var body: some View {
        ZStack {
            Color("background")
                .ignoresSafeArea()
            VStack {
                ForEach(GameDescriptor.all) { game in
                    Button(game.displayName) {
                        coordinator.gameSelected(game)
                    }
                }
            }
        }
        .navigationDestination(for: Coordinator.Path.self) { path in
            coordinator.navigate(to: path)
        }
        .sheet(item: $coordinator.sheet) { sheet in
            coordinator.navigate(to: sheet)
        }
        .fullScreenCover (item: $coordinator.fullscreen) { fullscreen in
            coordinator.navigate(to: fullscreen)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            // it is OK to update @Published vars here
            coordinator.handleRotation(UIDevice.current.orientation)
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
            .environmentObject(Coordinator())
    }
}
