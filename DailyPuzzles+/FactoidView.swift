import SwiftUI

struct FactoidView: View {
    let message: LocalizedStringKey = """
        Visit Apple: [click here](https://apple.com) This is **bold** text, this is *italic* text, and this is ***bold, italic*** text. ~~A strikethrough example~~ `Monospaced works too` 🙃 I recently befriended my neighbor and who is my dad’s age and in a wheelchair. He is so lonely because his wife died right around the time he lost his second leg.
        """
    private var isPad: Bool { UIDevice.current.userInterfaceIdiom == .pad }

    var body: some View {
        Text(message).minimumScaleFactor(0.1)
            .font(.system(size: isPad ? 18 : 14))
        .padding(.horizontal, 0).padding(.top, 8)
    }
}

struct FactoidView_Previews: PreviewProvider {
    static var previews: some View {
        FactoidView()
    }
}
