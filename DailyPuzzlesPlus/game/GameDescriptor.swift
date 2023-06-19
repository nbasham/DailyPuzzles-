import SwiftUI

enum GameDescriptor: String, Identifiable, Codable {

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

    var hasLevels: Bool {
        switch self {
            case .cryptogram:
                return false
            case .crypto_families:
                return false
            case .quotefalls:
                return false
            case .sudoku:
                return true
            case .word_search:
                return true
            case .memory:
                return true
            case .triplets:
                return true
            case .sample_game:
                return false
        } // next color ff00ff
    }

    @MainActor
    @ViewBuilder
    func view(host: GameHost, size: CGSize) -> some View {
        switch self {

            case .cryptogram:
                CryptogramView(host: host, size: size)
            case .crypto_families:
                CryptogramView(host: host, size: size)
            case .quotefalls:
                CryptogramView(host: host, size: size)
            case .sudoku:
                CryptogramView(host: host, size: size)
            case .word_search:
                CryptogramView(host: host, size: size)
            case .memory:
                MemoryView(viewModel: MemoryViewModel(host: host, size: size))
            case .triplets:
                CryptogramView(host: host, size: size)
            case .sample_game:
                CryptogramView(host: host, size: size)
        }
    }
}
