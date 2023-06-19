import SwiftUI

struct MenuItemView: View {
    let name: String
    let notificationName: NSNotification.Name
    let image: String
    @EnvironmentObject private var play: Play

    var body: some View {
        Button(action: {
            NotificationCenter.default.post(name: notificationName, object: nil)
            play.tap()
        }, label: {
            HStack {
                Text(name)
                    .fixedSize(horizontal: true, vertical: true)
                Spacer()
                Image(systemName: image)
            }
        })
    }
}

struct MenuItemView_Previews: PreviewProvider {
    static var help: some View {
        MenuItemView(name: "Help", notificationName: .help, image: "questionmark.circle")
            .environmentObject(Play())
    }
    static var helpDisabled: some View {
        MenuItemView(name: "Help", notificationName: .help, image: "questionmark.circle")
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
