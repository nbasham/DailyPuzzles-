import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: Settings
    @EnvironmentObject private var navigator: Navigator
    @EnvironmentObject private var play: Play

    var body: some View {
        ZStack {
            Color("background")
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 16) {
                Toggle("Show timer", isOn: settings.$timerOn)
                Toggle("Play sounds", isOn: $play.soundOn)
                Section("Volume level") {
                    Picker("Volume level", selection: $play.soundVolume) {
                        Text("Low").tag(0.2)
                        Text("Med").tag(0.5)
                        Text("High").tag(1.0)
                    }
                    .pickerStyle(.segmented)
                }
                .disabled(play.soundOn == false)
                Spacer()
            }
            .tint(Color("top"))
            .padding()
        }
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color("top"), for: .navigationBar)
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
