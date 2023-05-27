import SwiftUI

struct SettingsGameOrderView: View {
    @State var data = Settings.onGames()

    var body: some View {
        ZStack {
            Color("background")
                .ignoresSafeArea()
            List {
                ForEach(data, id: \.id, content: { game in
                    Text(game.displayName)
                        .tint(game.color)
                }).onMove { (source: IndexSet, destination: Int) in
                    data.move(fromOffsets: source, toOffset: destination)
                    print("source \(source)")
                    print("destination \(destination)")
                    print("data \(data)")
                    if let ordereddata = try? JSONEncoder().encode(data) {
                        UserDefaults.standard.set(ordereddata, forKey: "settings_game_order")
                    }
                }
            }.environment(\.editMode, .constant(.active))
        }
        .listStyle(InsetListStyle())
        .clipShape(RoundedRectangle(cornerRadius: 11))
        .padding()
    }
}

struct SettingsGameOrderView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsGameOrderView()
    }
}
