import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: Settings
    @EnvironmentObject private var navigator: Navigator

    var body: some View {
        ZStack {
            Color("background")
                .ignoresSafeArea()
            VStack(alignment: .leading) {
                Toggle("Show timer", isOn: settings.$timerOn)
                    .tint(Color("top"))
                Spacer()
            }
            .padding()
        }
        //        .navigationTitle("Settings")
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color("top"), for: .navigationBar)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
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
        }
    }
}
