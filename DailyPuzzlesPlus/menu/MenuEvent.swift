import Foundation

/**
 Events used by menu items and menu subscribers.

 **Posting a notification**
 ```
 NotificationCenter.default.post(name: .eventOccurred, object: nil)
 ```

 **Adding an observer **
 ```
 NotificationCenter.default.addObserver(self, selector: #selector(someMethod), name: .eventOccurred, object: nil)
 ```

 **SwiftUI's `onReceive` modifier **
 ```
 .onReceive(NotificationCenter.default.publisher(for: .eventOccurred)) { _ in
 }
 ```
 */
struct MenuEvent {
    private static let payloadKey = "menuItem"

    static func addMenuItem(_ item: MenuItemViewModel) {
        NotificationCenter.default.post(name: .addMenuItem, object: [payloadKey: item])
    }

    static func updateMenuItem(_ item: MenuItemViewModel) {
        addMenuItem(item)
    }

    static func removeMenuItem(_ item: MenuItemViewModel) {
        NotificationCenter.default.post(name: .removeMenuItem, object: [payloadKey : item])
    }

    static func payload(for notification: Notification) -> MenuItemViewModel? {
        guard let info = notification.object as? [String: MenuItemViewModel],
              let viewModel = info[payloadKey] else {
            return nil
        }
        return viewModel
    }
}

// MARK: - Notification Names

/// Notification names related to menu events.
extension NSNotification.Name {
    static let addMenuItem = NSNotification.Name("addMenuItem")
    static let removeMenuItem = NSNotification.Name("removeMenuItem")
}

/// Notification names related to game events.
extension NSNotification.Name {
    static let settings = NSNotification.Name("settings")
    static let gameTimer = NSNotification.Name("gameTimer")
    static let gameBackButton = NSNotification.Name("gameBackButton")
    static let gameHelp = NSNotification.Name("gameHelp")
    static let gameSolve = NSNotification.Name("gameSolve")
    static let gameStartAgain = NSNotification.Name("gameStartAgain")
}

/// Notification names specific to individual game types (e.g., Sudoku, Word Search).
extension NSNotification.Name {
    // Quotefalls
    static let autoAdvance = NSNotification.Name("autoAdvance")

    // Sudoku
    static let completeLastNumber = NSNotification.Name("completeLastNumber")
    static let placeMarkersTrailing = NSNotification.Name("placeMarkersTrailing")
    static let selectRowCol = NSNotification.Name("selectRowCol")
    static let undo = NSNotification.Name("undo")

    // Word Search
    static let hideClues = NSNotification.Name("hideClues")

    // Debugging
    static let almostSolveEvent = NSNotification.Name("almostSolveEvent")
}

/// Notification names for other app-wide events.
extension NSNotification.Name {
    static let contact = NSNotification.Name("contact")
    static let help = NSNotification.Name("help")
}
