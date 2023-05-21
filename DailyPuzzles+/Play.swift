import SwiftUI
import SwiftySound

//  https://swiftpackageindex.com/adamcichy/SwiftySound
class Play: ObservableObject {
    private let tapSound: Sound?
    private let highlightSound: Sound?
    private let incorrectSound: Sound?
    private let correctSound: Sound?
    private let hintSound: Sound?
    private let eraseSound: Sound?

    init() {
        Sound.enabled = true
        tapSound = Play.load("Touch")
        highlightSound = Play.load("Highlight")
        incorrectSound = Play.load("Incorrect")
        correctSound = Play.load("Correct")
        hintSound = Play.load("Hint")
        eraseSound = Play.load("Erase")
        print("IGNORE WARNING ABOVE: AddInstanceForFactory: No factory registered for id.")
    }

    private static func load(_ name: String) -> Sound? {
        if let url = Bundle.main.url(forResource: name, withExtension: "aiff"),
           let sound = Sound(url: url) {
            return sound
        }
        print("Unable to load sound file '\(name)'.")
        return nil
    }

    func tap() {
        tapSound?.play()
    }

    func highlight() {
        highlightSound?.play()
    }

    func incorrect() {
        incorrectSound?.play()
    }

    func correct() {
        correctSound?.play()
    }

    func hint() {
        hintSound?.play()
    }

    func erase() {
        eraseSound?.play()
    }
}
