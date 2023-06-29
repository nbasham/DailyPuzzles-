import SwiftUI

protocol GameHost {
    //  why does game need GameDescriptor? it knows what it is
    var game: GameDescriptor { get }
    func setTitle(title: String)
    func didSolve()
    func incMisses()
    func incHints()
    func prepareSound(soundName: String)
    func playSound(soundName: String)
    func playTap()
    func playHighlight()
    func playIncorrect()
    func playCorrect()
    func playHint()
    func playErase()
    func gameComplete()
}

struct GameHostView: View, GameHost {
    @EnvironmentObject private var navigator: Navigator
    @EnvironmentObject private var settings: Settings
    @Environment(\.isPreview) var isPreview
    @StateObject var viewModel: GameHostViewModel
    var game: GameDescriptor { viewModel.game }
    @State private var isGameDisabled = false
    @State private var title = ""

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            ZStack {
                Color.clear
                VStack(spacing: 0) {
                    GeometryReader { proxy in
                        game.view(host: self, size: proxy.size)
                            .disabled(isGameDisabled)
                            .transition(.scale)
                    }
                    if viewModel.showSolved {
                        GameSolvedView(game: game)
                            .frame(height: 88)
                            .transition(.move(edge: .bottom))
                    }
                }
            }
        }
        .onAppear {
            guard !isPreview else { return }
            viewModel.start()
        }
        .onDisappear {
            viewModel.stop()
        }
        .onReceive(NotificationCenter.default.publisher(for: .gameSolve)) { x in
            didSolve()
        }
        .onReceive(NotificationCenter.default.publisher(for: .gameBackButton)) { x in
            viewModel.save()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(title)
        //  make nav title white
        .toolbarColorScheme(.dark, for: .navigationBar)
        .navigationBarBackButtonHidden()
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(viewModel.game.color, for: .navigationBar)
        .toolbar {
            GameToolbarView(showTimer: settings.timerOn, isGameSolved: $viewModel.isSolved)
        }
    }

    func setTitle(title: String) {
        self.title = title
    }

    func didSolve() {
        DailyStorage.completed(game: game)
        withAnimation {
            isGameDisabled = true
            viewModel.didSolve()
        }
    }

    func incMisses() { viewModel.incMisses() }
    func incHints() { viewModel.incHints() }
    func prepareSound(soundName: String) { Play.prepare(soundName) }
    func playSound(soundName: String) { Play.play(soundName) }
    func playTap() { Play.tap() }
    func playHighlight() { Play.highlight() }
    func playIncorrect() { Play.incorrect() }
    func playCorrect() { Play.correct() }
    func playHint() { Play.hint() }
    func playErase() { Play.erase() }
    func gameComplete() { Play.gameComplete() }
}

struct GameHostView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            GameHostView(viewModel: GameHostViewModel(game: .memory))
                .environmentObject(Navigator())
                .environmentObject(Settings())
        }
    }
}

@MainActor
class GameHostViewModel: ObservableObject {
    let game: GameDescriptor
    @Published var isSolved = false
    @Published var showSolved = false
    var gameModel = GameModel()
    let timer = SecondsTimer()

    init(game: GameDescriptor) {
        self.game = game
    }

    //  init is called twice, appear (which calls this) only once
    func start() {
        gameModel = GameModel.load(game: game)
        timer.start(initialSeconds: gameModel.elapsedSeconds) { secs in
            self.gameModel.elapsedSeconds = secs
            NotificationCenter.default.post(name: .gameTimer, object: ["secs": NSNumber(value: secs)])
        }
        startEventListening()
    }

    func stop() {
        stopEventListening()
        timer.end()
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
        timer.resume()
    }

    @objc func appMovedToBackground() {
        print("App moved to background!")
        timer.pause()
        save()
    }

    func didSolve() {
        Play.gameComplete()
        timer.pause()
        isSolved = true
        showSolved = true
        GameModel.clear(game: game)
        // TODO remove game's persistence
    }

    func save() {
        if !isSolved {
            gameModel.save(game: game)
        }
    }

    func incMisses() { gameModel.numberMissed += 1 }
    func incHints() { gameModel.numberOfHintsUsed += 1 }
}
