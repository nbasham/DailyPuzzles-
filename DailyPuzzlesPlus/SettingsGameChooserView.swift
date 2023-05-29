import SwiftUI

struct SettingsGameChooserView: View {
    @EnvironmentObject private var navigator: Navigator
    @EnvironmentObject private var play: Play
    @State private var isOn = GameDescriptor.all.map { Settings.isGameOn($0) }

    var body: some View {
        ZStack {
            Color("background")
                .ignoresSafeArea()
            List {
                VStack {
                    Text("Choose games")
                        .font(.headline)
                        .padding(.bottom, 4)
                        .frame(maxWidth: .infinity)
                    Text("Select the games you want to play, only selected games will appear. At least one game must be selected.")
                        .foregroundColor(.secondary)
                        .font(.caption)
                        .fixedSize(horizontal: false, vertical: true)
                }
                ForEach(Array(zip(GameDescriptor.all.indices, GameDescriptor.all)), id: \.0) { index, game in
                    HStack {
                        Image(systemName: isOn[index] ? "checkmark.circle" : "circle")
                            .imageScale(.large)
                            .background(
                                game.color.opacity(0.25)
                                    .clipShape(Circle())
                            )
                            .foregroundColor(.primary)
                        Text(game.displayName)
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        Settings.toggleGame(game)
                        isOn[index] = Settings.isGameOn(game)
                    }
                }
            }
            .listStyle(InsetListStyle())
            .clipShape(RoundedRectangle(cornerRadius: 11))
            .padding()
        }
//        .toolbarBackground(.visible, for: .navigationBar)
//        .toolbarBackground(Color("top"), for: .navigationBar)
//        .navigationBarBackButtonHidden()
//        .toolbar {
//            ToolbarItem(placement: .navigationBarLeading) {
//                Button(action: {
//                    play.tap()
//                    navigator.pop()
//                }, label: {
//                    HStack {
//                        Label("back", systemImage: "chevron.left.circle.fill")
//                            .imageScale(.large)
//                            .foregroundColor(.white)
//                        Text("back")
//                            .foregroundColor(.white)
//                            .fontWeight(.light)
//                    }
//                })
//            }
//        }
    }
}

struct SettingsGameChooserView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsGameChooserView()
    }
}
