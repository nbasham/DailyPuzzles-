import SwiftUI

final class ContentService: ObservableObject {
/*
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(lowMemoryWarning), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(cloudUpdate(_:)), name: CloudKitDataReceivedNotification, object: nil)
    }

    @objc func lowMemoryWarning() {
        print("lowMemoryWarning")
    }

    @objc func cloudUpdate(_ notification: NSNotification) {
        print("cloudUpdate")
        if let type = notification.userInfo?["type"] as? String {
            print(type)
            if type == "factoids" {
            }
        }
    }
*/
    var factoid: String {
        guard !DailyStorage.allCompleted() else { return "Congratulations, you've solved today's puzzles! More at midnight..." }
        let timer = CodeTimer()
        let factoidUpdates = AppSupportFile.load("factoidUpdates.txt") as? [String] ?? Bundle.lines(from: "factoidUpdates")
        if let update = factoidUpdates?.first(where: { str in
            str.starts(with: Date.yymmdd)
        }) {
            timer.log("Time to load updated factoid:")
           return String(update.dropFirst(9))
        }

        return todaysLine(from: "factoids")
    }

    func puzzleForGame(_ game: GameDescriptor) -> String {
        //  TODO check for puzzle level
        return todaysLine(from: "\(game.id)_puzzle")
    }

    private func todaysLine(from fileName: String) -> String {
        let timer = CodeTimer()
        let lines = AppSupportFile.load("\(fileName).txt") as? [String] ?? Bundle.lines(from: fileName)
        let key = Date.ddmm
        let line = lines?.first { str in
            str.starts(with: key)
        }
        if let line, line.count > 5 {
            timer.log("Time to load line \(key) from '\(fileName).txt':")
            return String(line.dropFirst(5))
        } else {
            timer.log("Time:")
            print("Error loading line \(key) from '\(fileName).txt'.")
            return "Error"
        }
    }
}
