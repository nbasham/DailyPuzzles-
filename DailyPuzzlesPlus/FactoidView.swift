import SwiftUI

struct FactoidView: View {
    @EnvironmentObject private var service: ContentService
    @Environment(\.isPreview) var isPreview
    @Environment(\.colorScheme) var colorScheme
    @State internal var message: LocalizedStringKey = ""

    var body: some View {
        Text(message)
            //  using .weight will cancel markdown
            .font(.system(size: 18))
            .minimumScaleFactor(0.1)
            .padding(.horizontal, 0)
            .padding(.top, 8)
            .padding(.bottom, 4)
            .tint(.primary) // markup links don't show in dark mode, this says make a link look like regular text
//            .tint(colorScheme == .dark ? .yellow : .blue)
            .multilineTextAlignment(.leading)
            .onAppear {
                guard !isPreview else { return }
                message = LocalizedStringKey(service.factoid)
            }
            .onReceive(NotificationCenter.default.publisher(for: .dateChange)) { _ in
                message = LocalizedStringKey(service.factoid)
            }
            .onReceive(NotificationCenter.default.publisher(for: CloudKitDataReceivedNotification)) { _ in
                message = LocalizedStringKey(service.factoid)
            }
    }
}

struct FactoidView_Previews: PreviewProvider {
    static let markdownMessage: LocalizedStringKey = """
        Visit Apple: [click here](https://apple.com) This is **bold** text, this is *italic* text, and this is ***bold, italic*** text. ~~A strikethrough example~~ `Monospaced works too` 🙃
        """
    static let shortMessage: LocalizedStringKey = "On this day in 1973, televised Watergate hearings begin."
    static let longMessage: LocalizedStringKey = "On this day in 1946, the Bikini is introduced. French designer Louis Reard unveils a daring two-piece swimsuit at the Piscine Molitor, a popular swimming pool in Paris."

    static var previews: some View {
        VStack {
            Text("Markdown: Be sure to test link color in dark mode")
                .font(.caption2)
                .foregroundColor(.secondary)
            FactoidView(message: markdownMessage)
            Divider()
            Text("Short message: Be sure to test width")
                .font(.caption2)
                .foregroundColor(.secondary)
            FactoidView(message: shortMessage)
            Divider()
            Text("Long message")
                .font(.caption2)
                .foregroundColor(.secondary)
            FactoidView(message: longMessage)
        }
            .padding(.horizontal)
    }
}
