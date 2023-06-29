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
                MemoryView(viewModel: MemoryViewModel(host: host, size: size, level: GameLevel.value(forGame: .memory)))
            case .triplets:
                CryptogramView(host: host, size: size)
            case .sample_game:
                CryptogramView(host: host, size: size)
        }
    }

    var appUrl: URL? {
        let dpScheme = "com.blacklabs.dailypuzzles"
        let urlStr = "\(self.scheme)://?source=\(dpScheme)"
        return URL.init(string: urlStr)
    }

    var appStoreUrl: URL? {
        return URL.init(string: self.storeLink)
    }

    fileprivate var storeLink: String {
        var link: String
        switch self {
            case .cryptogram:
                link = "https://itunes.apple.com/us/app/cryptogram-round/id1013610861?mt=8&at=1010lokd&ct=dpplaunch"
            case .crypto_families:
                link = "https://itunes.apple.com/us/app/crypto-families-round/id1093561769?mt=8&at=1010lokd&ct=dpplaunch"
            case .quotefalls:
                link = "https://itunes.apple.com/us/app/quotefalls-round/id1103536176?mt=8&at=1010lokd&ct=dpplaunch"
            case .sudoku:
                link = "https://itunes.apple.com/us/app/sudokus-round/id1109102683?mt=8&at=1010lokd&ct=dpplaunch"
            case .word_search:
                link = "https://itunes.apple.com/us/app/word-search-round/id1148342858?ls=1&mt=8&at=1010lokd&ct=dpplaunch"
            case .memory:
                link = "https://itunes.apple.com/us/app/memory-round/id1132722898?ls=1&mt=8&at=1010lokd&ct=dpplaunch"
            case .triplets:
                link = "https://itunes.apple.com/us/app/triplets/id1551245829?ls=1&mt=8&at=1010lokd&ct=dpplaunch"
            case .sample_game:
                fatalError("Must impleent for Sample Game")
        }
        return link
    }

    var scheme: String {
        var scheme: String
        switch self {
            case .cryptogram:
                scheme = "com.blacklabs.cryptogram"
            case .crypto_families:
                scheme = "com.blacklabs.cryptofamilies"
            case .quotefalls:
                scheme = "com.blacklabs.quotefalls"
            case .sudoku:
                scheme = "com.blacklabs.sudoku"
            case .word_search:
                scheme = "com.blacklabs.wordsearch"
            case .memory:
                scheme = "com.blacklabs.memory"
            //  TODO these need to be defined
            case .triplets:
                scheme = "com.blacklabs.triplets"
            case .sample_game:
                scheme = "com.blacklabs.samplegame"
        }
        return scheme
    }
}
