import SwiftUI

struct SettingsGameOrderView: View {
    @State var data: [GameDescriptor]

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
//                    Settings.saveGameOrder(data)
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
        SettingsGameOrderView(data: GameDescriptor.all)
    }
}
