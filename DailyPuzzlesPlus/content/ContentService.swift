import SwiftUI

/**
 Daily content adhere’s to a convention where a text file contains lines of content and each of these lines is prefixed with MMdd\t (i.e. two digits representing month, two digits representing day, and a tab delimiter). Given a file name a String is retrieved based on the current date. The app ships with such files in its Bundle but the first time the app runs it moves them to the App Support directory where they can be modified, this is the only time the Bundle files are accessed. Additionally, the first time the app is run a request is made to iCloud to get the file and overwrite the current file in case there has been an update. Anytime a file is uploaded to iCloud it is automatically distributed to all users and silently overwrites the older file. A year’s content can be handled with 367 lines, and since these files can be loaded on a device in roughly a millisecond they are loaded each time the data is requested. The app also has a convention for level so a request for daily content automatically loads content based on the current level specified by the user. As the MMdd can serve as a unique identifier, logic can be performed at runtime to ensure that saved game state is not stale and should be associated with specific content.

 In the future we may want more than one years content to keep the data feeling fresher. We can handle this much the same way we do levels, loading different files based on criteria (e.g. year is odd or even). Storing Data vs. String would be more flexible but thus far all game’s content needs are satisfied by String (the String may contain delimiters or even JSON).
 ```
 Pseudo code:
 let content = ContentService(“memory”)
 let memoryPuzzle = MemoryPuzzle(content)
 ```
 */
final class ContentService: ObservableObject {
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

    var memory: String {
        return gameContent(.memory)
    }

    private func gameContent(_ game: GameDescriptor) -> String {
        if game.hasLevels {
            let level = GameLevel.value(forGame: game)
            return todaysLine(from: "\(game.id)_puzzles_\(level.key)")
        }
        return todaysLine(from: "\(game.id)_puzzles")
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
