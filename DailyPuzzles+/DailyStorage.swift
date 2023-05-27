import Foundation

extension UserDefaults {
    static var daily: UserDefaults {
        return UserDefaults(suiteName: "dailypuzzles.daily")!
    }
}

fileprivate extension UserDefaults {
    static func clearDaily() {
#if !isPreview
        let dictionary = UserDefaults.daily.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            UserDefaults.daily.removeObject(forKey: key)
        }
        UserDefaults.daily.synchronize()
#endif
    }
}

struct DailyStorage {
    @discardableResult
    static func isNewDay() -> Bool {
#if isPreview
        return false
#else
        guard let datestamp = UserDefaults.daily.object(forKey: "daily.datestamp") as? String else { return false }
        guard datestamp != Date.yyddmm else { return false }
        UserDefaults.clearDaily()
        NotificationCenter.default.post(name: .dateChange, object: nil)
        return true
#endif
    }

    private static func key(game: GameDescriptor) -> String {
        "\(Date.yyddmm)_\(game.id)_completed"
    }

    static func completed(game: GameDescriptor) {
        UserDefaults.daily.set(true, forKey: key(game: game))
    }

    static func isCompleted(game: GameDescriptor) -> Bool {
#if isPreview
        return false
#else
        UserDefaults.daily.value(forKey: key(game: game)) != nil
#endif
    }

    static func allCompleted(games: [GameDescriptor]) -> Bool {
        for game in games {
            if !isCompleted(game: game) {
                return false
            }
        }
        return true
    }
}

extension NSNotification.Name {
    static let dateChange = NSNotification.Name("dateChange")
}
