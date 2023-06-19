import SwiftUI

struct SettingsGameOrderView: View {
    @State var data: [GameDescriptor]

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            List {
                VStack {
                    Text("Order games")
                        .font(.headline)
                        .padding(.bottom, 4)
                        .frame(maxWidth: .infinity)
                    Text("Use the tab on the right to drag games into the order you wish to play them")
                        .foregroundColor(.secondary)
                        .font(.caption)
                        .fixedSize(horizontal: false, vertical: true)
                }
                ForEach(data.indices, id: \.self, content: { index in
                    let game = data[index]
                   HStack {
                       Image(systemName: "\(index+1).circle")
                           .foregroundColor(game.color)
                       Text(game.displayName)
                       if !Settings.isGameOn(game) {
                           Text("(not shown)")
                               .foregroundColor(.secondary)
                               .font(.caption)
                       }
                       Spacer()
                   }
                }).onMove { (source: IndexSet, destination: Int) in
                    data.move(fromOffsets: source, toOffset: destination)
                    Settings.saveGameOrder(data)
                }
            }
                .environment(\.editMode, .constant(.active))
                .listStyle(InsetListStyle())
                .clipShape(RoundedRectangle(cornerRadius: 11))
                .padding()
        }
        .onAppear {
            data = Settings.loadGameOrder()
        }
        .navigationBarItems(trailing:
                                Button(action: {
            Settings.restoreOrder()
            data = GameDescriptor.all
        }) {
            Text("Restore")
        }
        )
    }
}

struct SettingsGameOrderView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsGameOrderView(data: GameDescriptor.all)
    }
}
