import SwiftUI

protocol GameHost {
    //  why does game need GameDescriptor? it knows what it is
    var game: GameDescriptor { get }
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
}

struct GameHostView: View, GameHost {
    @EnvironmentObject private var navigator: Navigator
    @EnvironmentObject private var play: Play
    @EnvironmentObject private var settings: Settings
    @Environment(\.isPreview) var isPreview
    @StateObject var viewModel: GameHostViewModel
    var game: GameDescriptor { viewModel.game }
    @State private var isGameDisabled = false

    var body: some View {
        ZStack {
            Color("background")
                .ignoresSafeArea()
            ZStack {
                Color.clear
                VStack(spacing: 0) {
                    GeometryReader { proxy in
                        game.view(host: self, size: proxy.size)
                            .disabled(isGameDisabled)
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
        .navigationBarBackButtonHidden()
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(viewModel.game.color, for: .navigationBar)
        .toolbar {
            GameToolbarView(showTimer: settings.timerOn, seconds: viewModel.gameModel.elapsedSeconds.timerValue)
        }
    }

    func didSolve() {
        DailyStorage.completed(game: game)
        isGameDisabled = true
        viewModel.didSolve()
    }

    func incMisses() { viewModel.incMisses() }
    func incHints() { viewModel.incHints() }
    func prepareSound(soundName: String) { play.prepare(soundName) }
    func playSound(soundName: String) { play.play(soundName) }
    func playTap() { play.tap() }
    func playHighlight() { play.highlight() }
    func playIncorrect() { play.incorrect() }
    func playCorrect() { play.correct() }
    func playHint() { play.hint() }
    func playErase() { play.erase() }
}

struct GameHostView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            GameHostView(viewModel: GameHostViewModel(game: .memory))
                .environmentObject(Navigator())
                .environmentObject(Settings())
                .environmentObject(Play())
        }
    }
}

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

struct GameSolvedView: View {

    var body: some View {
        ZStack {
            Color.yellow
        }
        .ignoresSafeArea()
    }
}

//struct GameSolvedView_Previews: PreviewProvider {
//    static var previews: some View {
//        GameSolvedView()
//    }
//}
