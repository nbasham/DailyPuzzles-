import Foundation

struct GameModel: Codable {
    var elapsedSeconds : Int
    var numberOfHintsUsed : Int
    var numberMissed : Int
    var data: Data? { try? JSONEncoder().encode(self) }
    private static func key(_ game: GameDescriptor) -> String {
        "\(game.id)_\(Date.ddmm)_host_state"
    }

    init() {
        self.elapsedSeconds = 0
        self.numberOfHintsUsed = 0
        self.numberMissed = 0
    }

    static func fromData(_ data: Data) -> Self? {
        (try? JSONDecoder().decode(GameModel.self, from: data))
    }

    static func load(game: GameDescriptor) -> Self {
        if let data = UserDefaults.daily.object(forKey: key(game)) as? Data,
           let model = GameModel.fromData(data) {
            return model
        } else {
            return GameModel()
        }
    }

    static func clear(game: GameDescriptor) {
        UserDefaults.daily.removeObject(forKey: key(game))
    }

    func save(game: GameDescriptor) {
        if let data {
            UserDefaults.daily.set(data, forKey: GameModel.key(game))
        }
    }
}
