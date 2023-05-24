import SwiftUI

class Settings: ObservableObject {
    // Get app storage and published behavior!
    @AppStorage("timerOn") var timerOn: Bool = true {
        willSet {
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }

    static private func isGameOnKey(_ game: GameDescriptor) -> String {
        "\(game.id)_settings_isOn"
    }
    static func onGames() -> [GameDescriptor] {
        GameDescriptor.all.filter { Settings.isGameOn($0) }
    }
    static func toggleGame(_ game: GameDescriptor) {
        let key = Settings.isGameOnKey(game)
        let isOn = UserDefaults.standard.object(forKey: key) as? Bool ?? true
        UserDefaults.standard.set(!isOn, forKey: key)
    }
    static func isGameOn(_ game: GameDescriptor) -> Bool {
        let key = Settings.isGameOnKey(game)
        let isOn = UserDefaults.standard.object(forKey: key) as? Bool ?? true
        return isOn
    }
}

