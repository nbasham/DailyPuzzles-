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
        let onGames = GameDescriptor.all.filter { Settings.isGameOn($0) }
        let key = "settings_game_order"
        if let data = UserDefaults.standard.object(forKey: key) as? Data,
        let orderedGames = try? JSONDecoder().decode([GameDescriptor].self, from: data) {
            //  TODO games on could have changed after ordering and this list is no longer correct
            return orderedGames
        }
        return onGames
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

