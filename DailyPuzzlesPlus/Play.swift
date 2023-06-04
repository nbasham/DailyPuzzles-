import SwiftUI
import SwiftySound

@MainActor
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
    private var gameSounds: [String: Sound] = [:]

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
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
        } else {
            guard UserDefaults.standard.object(forKey: "isPreview") as? Bool == false else { return }
            sound?.volume = Float(soundVolume)
            sound?.play()
        }
    }

    func prepare(_ soundName: String) {
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            print("Ignoring Play.prepare() for previews")
        } else {
            print("Play.prepare() is implemented")
            guard gameSounds[soundName] == nil else { return }
            if let sound = Play.load(soundName) {
                gameSounds[soundName] = sound
            }
        }
    }

    func play(_ soundName: String) {
        if let sound = gameSounds[soundName] {
            _play(sound)
        } else {
            print("\(soundName) not found, be sure you called prepare.")
        }
    }

    func tap() { _play(tapSound) }
    func highlight() { _play(highlightSound) }
    func incorrect() { _play(incorrectSound) }
    func correct() { _play(correctSound) }
    func hint() { _play(hintSound) }
    func erase() { _play(eraseSound) }
}
