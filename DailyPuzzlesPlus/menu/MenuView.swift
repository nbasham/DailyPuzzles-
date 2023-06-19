import SwiftUI

/**
 `MenuView` contains a `MenuTitleView` and a `Set` of `MenuItemView`s. It relys on SwiftUI's `Menu` implementation and adds a sound when a menu is tapped as well as a generalized way to express the menu items and their actions.

 `NotificationCenter` is used to post events when a menu item is choosen. Menu items can also be added or modified by sending a notification enabling games to add menu items e.g.
 ```
 NotificationCenter.default.post(name: .addMenuItem, object: ["menuItem": item])
```
 Storing menu item descriptions as a `Set` means that you can update a menu item by re-adding it. Menu items use their notification name to satisfy `Identifiable`.
 */
struct MenuView<Content: View>: View {
    @EnvironmentObject private var play: Play
    @State var items: Set<MenuItemViewModel>
    @ViewBuilder var content: Content

    var body: some View {
        Menu {
            ForEach(Array(items).sorted(by: >)) { item in
                MenuItemView(name: item.name, notificationName: item.notificationName)
            }
        } label: {
            content
        }

        //  foregroundColor and buttonStyle modifiers make the disabled modifier tint color work as expected
        .foregroundColor(.white)
        .buttonStyle(.plain)

        .onReceive(NotificationCenter.default.publisher(for: .addMenuItem)) { notification in
            if let vm = MenuEvent.payload(for: notification) {
                items.insert(vm)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .removeMenuItem)) { notification in
            if let vm = MenuEvent.payload(for: notification) {
                items.remove(vm)
            }
        }
        .onTapGesture {
            play.tap()
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static let items: Set<MenuItemViewModel> = [
        .help,
        .settings
    ]
    static var menu: some View {
        ZStack {
            Color.top
            VStack {
                MenuView(items: items) {
                    MainMenuTitleView()
                }
            }
        }
        .frame(maxHeight: 44)
    }
    static var menuDisabled: some View {
        ZStack {
            Color.top
            VStack {
                MenuView(items: items) {
                    MainMenuTitleView()
                }
            }
        }
        .frame(maxHeight: 44)
        .disabled(true)
    }
    static var previews: some View {
        menu
            .previewDisplayName("menu")
        menuDisabled
            .previewDisplayName("menuDisabled")
    }
}
