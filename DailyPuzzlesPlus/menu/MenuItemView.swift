import SwiftUI

struct MenuItemView: View {
    let name: String
    let notificationName: NSNotification.Name
    @EnvironmentObject private var play: Play

    var body: some View {
        Button(name, action: {
            NotificationCenter.default.post(name: notificationName, object: nil)
            play.tap()
        } )
    }
}

struct MenuItemView_Previews: PreviewProvider {
    static var help: some View {
        MenuItemView(name: "Help", notificationName: .help)
            .environmentObject(Play())
    }
    static var helpDisabled: some View {
        MenuItemView(name: "Help", notificationName: .help)
            .disabled(true)
            .environmentObject(Play())
    }
    static var previews: some View {
        help
            .previewDisplayName("help")
        helpDisabled
            .previewDisplayName("helpDisabled")
    }
}
