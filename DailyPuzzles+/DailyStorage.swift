import Foundation

extension UserDefaults {
    static var daily: UserDefaults {
        return UserDefaults(suiteName: "dailypuzzles.daily")!
    }
}

fileprivate extension UserDefaults {
    static func clearDaily() {
        let dictionary = UserDefaults.daily.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            UserDefaults.daily.removeObject(forKey: key)
        }
        UserDefaults.daily.synchronize()

    }
}

struct DailyStorage {
    @discardableResult
    static func isNewDay() -> Bool {
        guard let datestamp = UserDefaults.daily.object(forKey: "daily.datestamp") as? String else { return false }
        guard datestamp != Date.yyddmm else { return false }
        UserDefaults.clearDaily()
        return true
    }

    private static func key(game: GameDescriptor) -> String {
        "\(Date.yyddmm)_\(game.id)_completed"
    }

    static func completed(game: GameDescriptor) {
        UserDefaults.daily.set(true, forKey: key(game: game))
    }

    static func isCompleted(game: GameDescriptor) -> Bool {
        UserDefaults.daily.value(forKey: key(game: game)) != nil
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
