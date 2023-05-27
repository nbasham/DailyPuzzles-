import SwiftUI

class Settings: ObservableObject {
    @Environment(\.isPreview) var isPreview

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
#if isPreview
        return GameDescriptor.all.filter { Settings.isGameOn($0) }
#else
        let onGames = GameDescriptor.all.filter { Settings.isGameOn($0) }
        let key = "settings_game_order"
        if let data = UserDefaults.standard.object(forKey: key) as? Data,
        let orderedGames = try? JSONDecoder().decode([GameDescriptor].self, from: data) {
            //  TODO games on could have changed after ordering and this list is no longer correct
            return orderedGames
        }
        return onGames
#endif
    }
    static func saveGameOrder(_ data: [GameDescriptor]) {
#if !isPreview
        if let ordereddata = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(ordereddata, forKey: "settings_game_order")
        }
#endif
    }

    static func toggleGame(_ game: GameDescriptor) {
#if !isPreview
        let key = Settings.isGameOnKey(game)
        let isOn = UserDefaults.standard.object(forKey: key) as? Bool ?? true
        UserDefaults.standard.set(!isOn, forKey: key)
#endif
    }

    static func isGameOn(_ game: GameDescriptor) -> Bool {
#if isPreview
        return true
#else
        let key = Settings.isGameOnKey(game)
        let isOn = UserDefaults.standard.object(forKey: key) as? Bool ?? true
        return isOn
#endif
    }
}

