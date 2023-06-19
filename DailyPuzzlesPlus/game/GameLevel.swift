import Foundation

enum GameLevel: Int, Identifiable, CaseIterable, Codable, Hashable {
case easy = 1, medium = 2, hard = 3

    var id: Int { self.rawValue }

    var key: String {
        switch self {
            case .easy:
                return "easy"
            case .medium:
                return "medium"
            case .hard:
                return "hard"
        }
    }

    var displayName: String {
        switch self {
            case .easy:
                return "Easy"
            case .medium:
                return "Medium"
            case .hard:
                return "Hard"
        }
    }

    static func set(level: GameLevel, forGame game: GameDescriptor) {
        let key = "\(game.id)_level"
        UserDefaults.standard.set(level.rawValue, forKey: key)
        //  TODO broadcast to all devices this value
    }

    static func value(forGame game: GameDescriptor) -> GameLevel {
        let key = "\(game.id)_level"
        let value: Int = UserDefaults.standard.object(forKey: key) as? Int ?? GameLevel.easy.rawValue
        return GameLevel(rawValue: value) ?? GameLevel.easy
    }
}
