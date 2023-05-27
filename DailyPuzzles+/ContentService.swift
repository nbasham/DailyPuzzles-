import SwiftUI

final class ContentService: ObservableObject {

    private var _factoids: [String]?
    private var factoids: [String] {
        if let _factoids { return _factoids }
        else {
            _factoids = ContentService.lines(from: "factoids")
            return _factoids ?? []
        }
    }

    private var _factoidUpdates: [String]?
    private var factoidUpdates: [String] {
        if let _factoidUpdates { return _factoidUpdates }
        else {
            _factoidUpdates = ContentService.lines(from: "factoidUpdates")
            return _factoidUpdates ?? []
        }
    }

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(lowMemoryWarning), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
    }

    @objc func lowMemoryWarning() {
        print("lowMemoryWarning")
        _factoids = nil
        _factoidUpdates = nil
    }

    var factoid: String {
        if let update = factoidUpdates.first(where: { str in
            str.starts(with: Date.yymmdd)
        }) {
            return String(update.dropFirst(9))
        }

        let line = factoids.first { str in
            str.starts(with: Date.ddmm)
        }
        if let line {
            return String(line.dropFirst(5))
        } else {
            return "Error in ContentService"
        }
    }

    private static func lines(from file: String) -> [String] {
        if let path = Bundle.main.path(forResource: file, ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let lines = data.components(separatedBy: .newlines)
                return lines
            } catch {
                fatalError(error.localizedDescription)
            }
        }
        assertionFailure("'\(file)' not loaded")
        return []
    }

}
