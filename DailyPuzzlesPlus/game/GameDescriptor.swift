import SwiftUI

enum GameDescriptor: String, Identifiable, Codable {

    case cryptogram, crypto_families, quotefalls, sudoku, word_search, memory, triplets, sample_game

    static let all: [GameDescriptor] = [.cryptogram, .crypto_families, .quotefalls, .sudoku, .word_search, .memory, .triplets, .sample_game]

    var displayName: String {
        if self == .crypto_families {
            return "Crypto-Families"
        }
        return rawValue.capitalized.replacingOccurrences(of: "_", with: " ")
    }

    var id: String { self.rawValue }

    private static let colors: [GameDescriptor: Color] = [
        .cryptogram: .red,
        .crypto_families: .yellow,
        .quotefalls: .green,
        .sudoku: .blue,
        .word_search: .pink,
        .memory: .purple,
        .triplets: .orange,
        .sample_game: .cyan
    ]
    
    var color: Color {
        return Self.colors[self] ?? .clear
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
        }
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

    private static let baseURL = "https://itunes.apple.com/us/app/"
    internal var storeLink: String {
        var link: String
        switch self {
            case .cryptogram:
                link = "\(Self.baseURL)cryptogram-round/id1013610861?mt=8&at=1010lokd&ct=dpplaunch"
            case .crypto_families:
                link = "\(Self.baseURL)crypto-families-round/id1093561769?mt=8&at=1010lokd&ct=dpplaunch"
            case .quotefalls:
                link = "\(Self.baseURL)quotefalls-round/id1103536176?mt=8&at=1010lokd&ct=dpplaunch"
            case .sudoku:
                link = "\(Self.baseURL)sudokus-round/id1109102683?mt=8&at=1010lokd&ct=dpplaunch"
            case .word_search:
                link = "\(Self.baseURL)word-search-round/id1148342858?ls=1&mt=8&at=1010lokd&ct=dpplaunch"
            case .memory:
                link = "\(Self.baseURL)memory-round/id1132722898?ls=1&mt=8&at=1010lokd&ct=dpplaunch"
            case .triplets:
                link = "\(Self.baseURL)triplets/id1551245829?ls=1&mt=8&at=1010lokd&ct=dpplaunch"
            case .sample_game:
                fatalError("Must implement for Sample Game")
        }
        return link
    }

    internal var scheme: String {
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
