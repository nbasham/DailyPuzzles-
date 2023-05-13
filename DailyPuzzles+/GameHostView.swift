import SwiftUI

protocol GameHost {
    var game: GameDescriptor { get }
    func didSolve()
}

struct GameHostView: View, GameHost {
    @EnvironmentObject private var coordinator: Coordinator
    @ObservedObject var viewModel: GameHostViewModel
    var game: GameDescriptor { viewModel.game }

    var body: some View {
        ZStack {
            Color("background")
                .ignoresSafeArea()
            ZStack {
                Color.clear
                VStack(spacing: 0) {
                    GeometryReader { proxy in
                        CryptogramView(host: self, size: proxy.size)
                    }
                    if viewModel.showSolved {
                        GameSolvedView()
                            .frame(height: 88)
                            .transition(.move(edge: .bottom))
                    }
                }
            }
        }
        .onAppear {
            viewModel.startEventListening()
        }
        .onDisappear {
            viewModel.stopEventListening()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(viewModel.game.color, for: .navigationBar)
        .toolbar {
            GameToolbarView()
        }
    }

    func didSolve() {
        viewModel.didSolve()
    }
}

struct GameHostView_Previews: PreviewProvider {
    static var previews: some View {
        GameHostView(viewModel: GameHostViewModel(game: .quotefalls))
            .environmentObject(Coordinator())
    }
}

class GameHostViewModel: ObservableObject {
    let game: GameDescriptor
    @Published var isSolved = false
    @Published var showSolved = false

    init(game: GameDescriptor) {
        self.game = game
        NotificationCenter.default.addObserver(self, selector: #selector(appBecameActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
    }

    func startEventListening() {
        NotificationCenter.default.addObserver(self, selector: #selector(appBecameActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
    }

    func stopEventListening() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
    }

    @objc func appBecameActive() {
        print("App became active")
    }

    @objc func appMovedToBackground() {
        print("App moved to background!")
    }

    func didSolve() {
        isSolved = true
        showSolved = true
    }
}

struct GameSolvedView: View {

    var body: some View {
        ZStack {
            Color.yellow
        }
        .ignoresSafeArea()
    }
}

struct GameSolvedView_Previews: PreviewProvider {
    static var previews: some View {
        GameSolvedView()
    }
}
