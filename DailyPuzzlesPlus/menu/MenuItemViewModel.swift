import SwiftUI

class MenuItemViewModel: ObservableObject, Identifiable, Comparable, Hashable {

    let id: String
    let name: String
    let notificationName: NSNotification.Name
    let image: String

    init(name: String, notificationName: NSNotification.Name, image: String) {
        self.id = notificationName.rawValue
        self.name = name
        self.notificationName = notificationName
        self.image = image
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
    static let help = MenuItemViewModel(name: "Help", notificationName: .help, image: "questionmark.circle")
    static let settings = MenuItemViewModel(name: "Settings", notificationName: .settings, image: "gearshape")
    static let contact = MenuItemViewModel(name: "Contact us", notificationName: .contact, image: "square.and.pencil")
    static let gameSolve = MenuItemViewModel(name: "Solve", notificationName: .gameSolve, image: "pencil.and.scribble")
}
