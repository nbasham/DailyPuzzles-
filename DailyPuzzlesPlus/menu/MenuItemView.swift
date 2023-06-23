import SwiftUI

struct MenuItemView: View {
    let name: String
    let notificationName: NSNotification.Name
    let image: String

    var body: some View {
        Button(action: {
            NotificationCenter.default.post(name: notificationName, object: nil)
            Play.tap()
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
    }
    static var helpDisabled: some View {
        MenuItemView(name: "Help", notificationName: .help, image: "questionmark.circle")
            .disabled(true)
    }
    static var previews: some View {
        help
            .previewDisplayName("help")
        helpDisabled
            .previewDisplayName("helpDisabled")
    }
}
