import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: Settings
    @EnvironmentObject private var navigator: Navigator
    @EnvironmentObject private var play: Play
    var topPadding: CGFloat {
        guard UIDevice.isPhone else { return 16 }
        let isPortrait = UIDevice.current.orientation == .portrait
        return isPortrait ? 8 : 0
    }

    var body: some View {
        ZStack {
            Color("background")
                .ignoresSafeArea()
            Form {
                NavigationLink("Choose games", destination: SettingsGameChooserView())
               // Use GameDescriptor.all instead of onGames so we have a complete list, thus always in sync with each game
                NavigationLink("Order games", destination: SettingsGameOrderView(data: Settings.onGames()))
                    .accentColor(.top)
                Toggle("Show incorrect guesses", isOn: settings.$showIncorrect)
                VStack {
                    Toggle("Dark mode", isOn: settings.$darkMode)
                    Text("Choosing 'dark mode' sets it to always on, otherwise 'dark mode' is determeined by the system's settings.")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                }
                Toggle("Show timer", isOn: settings.$timerOn)
                Toggle("Play sounds", isOn: $play.soundOn)
                VStack(spacing: 4) {
                    Text("Volume level")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                    Picker("Volume level", selection: $play.soundVolume) {
                        Text("Low").tag(0.2)
                        Text("Med").tag(0.5)
                        Text("High").tag(1.0)
                    }
                    .pickerStyle(.segmented)
                    .frame(maxWidth: 320)
                }
                .listRowSeparator(Visibility.hidden)
                .padding(.horizontal)
                .disabled(play.soundOn == false)
            }
            .padding(.horizontal, UIDevice.isPad ? 64 : 16)
            .scrollContentBackground(.hidden)
            .tint(.top)
            .padding(.top, topPadding)
        }
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color.top, for: .navigationBar)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    play.tap()
                    navigator.pop()
                }, label: {
                HStack {
                    Label("back", systemImage: "chevron.left.circle.fill")
                        .imageScale(.large)
                        .foregroundColor(.white)
                    Text("back")
                        .foregroundColor(.white)
                        .fontWeight(.light)
                }
            })
            }
            ToolbarItem(placement: .principal) {
                Text("Settings")
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView()
                .environmentObject(Navigator())
                .environmentObject(Settings())
                .environmentObject(Play())
        }
    }
}
