import SwiftUI
import SwiftySound

//  https://swiftpackageindex.com/adamcichy/SwiftySound
class Play: ObservableObject {
    @Published var soundVolume: Double = 1.0
    @Published var soundOn: Bool = true {
        didSet {
            Sound.enabled = soundOn
        }
    }
    private let tapSound: Sound?
    private let highlightSound: Sound?
    private let incorrectSound: Sound?
    private let correctSound: Sound?
    private let hintSound: Sound?
    private let eraseSound: Sound?

    init() {
        tapSound = Play.load("Touch")
        highlightSound = Play.load("Highlight")
        incorrectSound = Play.load("Incorrect")
        correctSound = Play.load("Correct")
        hintSound = Play.load("Hint")
        eraseSound = Play.load("Erase")
        print("IGNORE CONSOLE WARNING ABOVE: AddInstanceForFactory: No factory registered for id.")
    }

    private static func load(_ name: String) -> Sound? {
        if let url = Bundle.main.url(forResource: name, withExtension: "aiff"),
           let sound = Sound(url: url) {
            return sound
        }
        print("Unable to load sound file '\(name)'.")
        return nil
    }

    private func _play(_ sound: Sound?) {
        sound?.volume = Float(soundVolume)
        sound?.play()
    }

    func tap() { _play(tapSound) }
    func highlight() { _play(highlightSound) }
    func incorrect() { _play(incorrectSound) }
    func correct() { _play(correctSound) }
    func hint() { _play(hintSound) }
    func erase() { _play(eraseSound) }
}
