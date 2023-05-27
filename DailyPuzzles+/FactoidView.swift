import SwiftUI

struct FactoidView: View {
    @EnvironmentObject private var service: ContentService
    @Environment(\.isPreview) var isPreview
    @State private var message: LocalizedStringKey = """
        Visit Apple: [click here](https://apple.com) This is **bold** text, this is *italic* text, and this is ***bold, italic*** text. ~~A strikethrough example~~ `Monospaced works too` 🙃
        """

    var body: some View {
        Text(message)
            //  using .weight will cancel markdown
            .font(.system(size: 18))
            .frame(maxWidth: .infinity)
            .minimumScaleFactor(0.1)
            .padding(.horizontal, 0)
            .padding(.top, 8)
            .padding(.bottom, 4)
            .onAppear {
                guard !isPreview else { return }
                message = LocalizedStringKey(service.factoid)
            }
            .onReceive(NotificationCenter.default.publisher(for: .dateChange)) { _ in
                message = LocalizedStringKey(service.factoid)
            }
    }
}

struct FactoidView_Previews: PreviewProvider {
    static var previews: some View {
        FactoidView()
            .padding(.horizontal)
    }
}
