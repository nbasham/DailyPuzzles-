import SwiftUI

enum GameDescriptor: String, Identifiable {

    case cryptogram, crypto_families, quotefalls, sudoku, word_search, memory, triplets, sample_game

    static let all: [GameDescriptor] = [.cryptogram, .crypto_families, .quotefalls, .sudoku, .word_search, .memory, .triplets, .sample_game]

    var displayName: String {
        var name: String
        switch self {
            case .cryptogram:
                name = "Cryptogram"
            case .crypto_families:
                name = "Crypto-Families"
            case .quotefalls:
                name = "Quotefalls"
            case .sudoku:
                name = "Sudoku"
            case .word_search:
                name = "Word Search"
            case .memory:
                name = "Memory"
            case .triplets:
                name = "Triplets"
            case .sample_game:
                name = "Sample Game"
        }
        return name
    }

    var id: String { self.rawValue }

    var color: Color {
        switch self {
            case .cryptogram:
                return .red
            case .crypto_families:
                return .yellow
            case .quotefalls:
                return .green
            case .sudoku:
                return .blue
            case .word_search:
                return .pink
            case .memory:
                return .purple
            case .triplets:
                return .orange
            case .sample_game:
                return .cyan
        } // next color ff00ff
    }

    func view(host: GameHost, size: CGSize) -> some View {
        CryptogramView(host: host, size: size)
    }
}
