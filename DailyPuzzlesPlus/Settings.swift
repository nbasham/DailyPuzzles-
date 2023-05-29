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
    @AppStorage("showIncorrect") var showIncorrect: Bool = true {
        willSet {
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }

    //  ON and ORDER

    static func onAndOrderedGames() -> [GameDescriptor] {
#if isPreview
        GameDescriptor.all
#else
        let onGames = Settings.loadGameOrder().filter { Settings.isGameOn($0) }
        return onGames
#endif
    }

    //  ORDER

    static private var gameOrderKey: String {
        "settings_game_order"
    }

    static func restoreOrder() {
        UserDefaults.standard.removeObject(forKey: Settings.gameOrderKey)
    }

    static func saveGameOrder(_ data: [GameDescriptor]) {
#if !isPreview
        if let ordereddata = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(ordereddata, forKey: gameOrderKey)
        }
#endif
    }

    static func loadGameOrder() -> [GameDescriptor] {
#if !isPreview
        if let data = UserDefaults.standard.object(forKey: gameOrderKey) as? Data,
            let games = try? JSONDecoder().decode([GameDescriptor].self, from: data) {
            return games
        }
        return GameDescriptor.all
#endif
    }

    //  ON

    static private func gameOnKey(_ game: GameDescriptor) -> String {
        "\(game.id)_settings_isOn"
    }

    static func turnAllOn() {
        GameDescriptor.all.forEach { UserDefaults.standard.set(true, forKey: Settings.gameOnKey($0)) }
    }

    static func dumpOn() {
        GameDescriptor.all.forEach {
            let isOn = UserDefaults.standard.object(forKey: Settings.gameOnKey($0))!
            print("\($0.id) \(isOn)")
        }
    }

    static func onGames() -> [GameDescriptor] {
#if isPreview
        GameDescriptor.all
#else
        let onGames = GameDescriptor.all.filter { Settings.isGameOn($0) }
        return onGames
#endif
    }

    static func toggleGame(_ game: GameDescriptor) {
#if !isPreview
        let key = Settings.gameOnKey(game)
        let isOn = UserDefaults.standard.object(forKey: key) as? Bool ?? true
        UserDefaults.standard.set(!isOn, forKey: key)
#endif
    }

    static func isGameOn(_ game: GameDescriptor) -> Bool {
#if isPreview
        return true
#else
        let key = Settings.gameOnKey(game)
        let isOn = UserDefaults.standard.object(forKey: key) as? Bool ?? true
        return isOn
#endif
    }
}

