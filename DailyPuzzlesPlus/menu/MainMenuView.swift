import MessageUI
import SwiftUI

struct MainMenuView: View {
    private let menuItems: Set<MenuItemViewModel>

    init() {
        var items: Set<MenuItemViewModel> = []
        if MFMailComposeViewController.canSendMail() {
            items.insert(MenuItemViewModel(name: "Contact us", notificationName: .contact))
        }
        items.insert(MenuItemViewModel(name: "Help", notificationName: .help))
        items.insert(MenuItemViewModel(name: "Settings", notificationName: .settings))
        menuItems = items
    }

    var body: some View {
        MenuView(items: menuItems) {
            MainMenuTitleView()
        }
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var mainMenu: some View {
        ZStack {
            Color("top")
            MainMenuView()
        }
        .frame(maxHeight: 44)
    }
    static var mainMenuDisabled: some View {
        ZStack {
            Color("top")
            MainMenuView()
        }
        .frame(maxHeight: 44)
        .disabled(true)
    }
    static var previews: some View {
        mainMenu
        mainMenuDisabled
    }
}
