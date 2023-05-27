import SwiftUI

struct FactoidView: View {
    @EnvironmentObject private var service: ContentService
    @State private var message: String = """
        Visit Apple: [click here](https://apple.com) This is **bold** text, this is *italic* text, and this is ***bold, italic*** text. ~~A strikethrough example~~ `Monospaced works too` 🙃
        """

    var body: some View {
        Text(message)
            .font(.system(size: 18, weight: .light))
            .frame(maxWidth: .infinity)
            .minimumScaleFactor(0.1)
            .padding(.horizontal, 0)
            .padding(.top, 8)
            .padding(.bottom, 4)
            .onAppear {
                message = service.factoid
            }
            .onReceive(NotificationCenter.default.publisher(for: .dateChange)) { _ in
                message = service.factoid
            }
    }
}

struct FactoidView_Previews: PreviewProvider {
    static var previews: some View {
        FactoidView()
    }
}
