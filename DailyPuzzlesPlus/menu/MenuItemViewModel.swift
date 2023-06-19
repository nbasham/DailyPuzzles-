import SwiftUI

class MenuItemViewModel: ObservableObject, Identifiable, Comparable, Hashable {

    let id: String
    let name: String
    let notificationName: NSNotification.Name

    init(name: String, notificationName: NSNotification.Name) {
        self.id = notificationName.rawValue
        self.name = name
        self.notificationName = notificationName
    }

    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }

    static func == (lhs: MenuItemViewModel, rhs: MenuItemViewModel) -> Bool {
        lhs.notificationName.rawValue == rhs.notificationName.rawValue
    }

    static func < (lhs: MenuItemViewModel, rhs: MenuItemViewModel) -> Bool {
        lhs.name > rhs.name
    }
}

extension MenuItemViewModel {
    static let help = MenuItemViewModel(name: "Help", notificationName: .help)
    static let settings = MenuItemViewModel(name: "Settings", notificationName: .settings)
    static let contact = MenuItemViewModel(name: "Contact us", notificationName: .contact)
    static let gameSolve = MenuItemViewModel(name: "Solve", notificationName: .gameSolve)
}
