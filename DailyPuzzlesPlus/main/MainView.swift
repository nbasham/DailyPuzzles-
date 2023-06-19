import SwiftUI

class MainViewModel: ObservableObject {
    @Published var inPortrait = false
    @Published var bottomViewHeight: CGFloat = 88
    @Published var chooserTopSpacing: CGFloat = 8
    @Published var chooserLineSpacing: CGFloat = 16
    @Published var overMinXMargin: CGFloat = 0
    var isPad: Bool { UIDevice.current.userInterfaceIdiom == .pad }
    private var isLandscape: Bool { !inPortrait }

    init() {
        if let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first,
           let interfaceOrientation = window.windowScene?.interfaceOrientation {
            self.inPortrait = interfaceOrientation == .portrait
            handleRotation(UIDevice.current.orientation)
        }
    }

    //  The starting point of the leading navigation bar item changes by device, the smallest device is 16 pixels in (e.g. iPhone SE). This method figures out the starting point for the device and subtracts the minumum so that the logo (the leading nav item) right aligns with game names below
    private func calcOffset() -> CGFloat {
        guard !inPortrait else { return 0 }
        guard let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first else { return 0 }
        guard let current = window.rootViewController?.systemMinimumLayoutMargins.leading else { return 0 }
        let minValue: CGFloat = 16 // e.g. SE
        return max(current - minValue, 0)
    }

    func handleRotation(_ orientation: UIDeviceOrientation) {
        //  for some reason an occasional .unknow is received
        guard orientation != .unknown else { return }
        inPortrait = orientation == .portrait
        overMinXMargin = calcOffset()
        if isPad {
            bottomViewHeight = 100
            chooserTopSpacing = 16
        } else {
            if inPortrait {
                bottomViewHeight = 88
                chooserTopSpacing = 16
                chooserLineSpacing = 16
            } else {
                bottomViewHeight = 54
                chooserTopSpacing = 8
                chooserLineSpacing = 5
            }
        }
    }
}

/*
 Todo figure out how to broadcast rotation changes
 */
struct MainView: View {
    @EnvironmentObject private var navigator: Navigator
    @EnvironmentObject private var play: Play
    @Environment(\.isPreview) var isPreview
    @State private var coverScreen: FullCoverPath?
    @StateObject var viewModel: MainViewModel
    @Environment(\.safeAreaDefault) var safeAreaDefault
    var safeAreaInsets: EdgeInsets { safeAreaDefault.wrappedValue }
    @Environment(\.portraitDefault) var portraitDefault
    var isPortrait: Bool { portraitDefault.wrappedValue }

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 0) {
                gameChooserView
                Spacer()
                FactoidView()
                    .padding(.leading, (viewModel.bottomViewHeight + safeAreaInsets.bottom)/2)
                    .padding(.horizontal)
                    .ignoresSafeArea()
                    .frame(maxWidth: .infinity)
                    .frame(height: viewModel.bottomViewHeight)
                    .background(
                        Color.top.opacity(0.2)
                            .ignoresSafeArea()
                    )
            }
            Circle()
                .foregroundColor(.top)
                .frame(height: viewModel.bottomViewHeight + safeAreaInsets.bottom)
                .offset(x: -(viewModel.bottomViewHeight + safeAreaInsets.bottom)/2)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            .ignoresSafeArea()
        }
        .onAppear {
            guard !isPreview else { return }
            DailyStorage.isNewDay()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            viewModel.handleRotation(UIDevice.current.orientation)
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
        .toolbarBackground(Color.top, for: .navigationBar)
        .toolbar { MainToolbarView(overMinXMargin: viewModel.overMinXMargin) }
    }

    private var gameChooserView: some View {
        VStack(spacing: viewModel.chooserLineSpacing) {
            ForEach(Settings.onAndOrderedGames()) { game in
                HStack {
                    HStack {
                        Spacer()
                        NavigationLink(game.displayName, value: game)
                    }
                        .frame(maxWidth: 200)
                        .tint(.primary)
                        .font(.system(size: 18, weight: .semibold))
                        .frame(width: 148)
                    Spacer().frame(width: 16)
                    MainBallView(game: game)
                        .frame(maxHeight: 34)
                    Spacer()
                }
                .padding(.leading)
                .contentShape(Rectangle())
                .onTapGesture {
                    play.tap()
                }
            }
        }
        .padding(.top, viewModel.chooserTopSpacing)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainViewModel())
            .environmentObject(Navigator())
            .environmentObject(Play())
    }
}
