import SwiftUI

//  "IGNORE CONSOLE WARNING ABOVE: AddInstanceForFactory: No factory registered for id."
@MainActor
//  https://swiftpackageindex.com/adamcichy/SwiftySound
class Play {
    static var soundVolume: Double = 1.0
    static var soundOn: Bool = true {
        didSet {
            Sound.enabled = soundOn
        }
    }
    private static let tapSound = Play.load("Touch")
    private static let highlightSound = Play.load("Highlight")
    private static let incorrectSound = Play.load("Incorrect")
    private static let correctSound = Play.load("Correct")
    private static let hintSound = Play.load("Hint")
    private static let eraseSound = Play.load("Erase")
    private static let gameCompleteSound = Play.load("GameComplete")
    private static var gameSounds: [String: Sound] = [:]

    private static func load(_ name: String) -> Sound? {
       if let url = Bundle.main.url(forResource: name, withExtension: "aiff"),
           let sound = Sound(url: url) {
            return sound
        }
        print("Unable to load sound file '\(name)'.")
        return nil
    }

    private static func _play(_ sound: Sound?) {
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
        } else {
            guard UserDefaults.standard.object(forKey: "isPreview") as? Bool == false else { return }
            sound?.volume = Float(soundVolume)
            sound?.play()
        }
    }

    static func prepare(_ soundName: String) {
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

    static func play(_ soundName: String) {
        if let sound = gameSounds[soundName] {
            _play(sound)
        } else {
            print("\(soundName) not found, be sure you called prepare.")
        }
    }

    static func tap() { _play(tapSound) }
    static func highlight() { _play(highlightSound) }
    static func incorrect() { _play(incorrectSound) }
    static func correct() { _play(correctSound) }
    static func hint() { _play(hintSound) }
    static func erase() { _play(eraseSound) }
    static func gameComplete() { _play(gameCompleteSound) }
}
