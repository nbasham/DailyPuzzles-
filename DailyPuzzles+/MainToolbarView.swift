import SwiftUI
import MessageUI

//  DOESN'T WORK IN SIMULATOR, be sure to import MessageUI into the Xcode project
struct MainToolbarView: ToolbarContent {
    @EnvironmentObject private var navigator: Navigator
    @EnvironmentObject private var play: Play

    var body: some ToolbarContent {
        Group {
            ToolbarItem(placement: .navigationBarLeading) {
                ZStack(alignment: .trailing) {
                    logoView
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                menuView()
            }
        }
    }

    private var logoView: some View {
        HStack(spacing: 2) {
            Text("Daily")
                .fontWeight(.light)
            Text("Puzzles")
                .fontWeight(.heavy)
        }
        .font(.system(size: 19))
        .foregroundColor(.white)
    }

    private func menuView() -> some View {
        Menu {
            if MFMailComposeViewController.canSendMail() {
                Button("Contact us", action: {
                    NotificationCenter.default.post(name: .contact, object: nil)
                    play.tap()
                } )
            }
            Button("Help", action: {
                NotificationCenter.default.post(name: .help, object: nil)
                play.tap()
            } )
            Button("Settings", action: {
                NotificationCenter.default.post(name: .settings, object: nil)
                play.tap()
            } )
        } label: {
            HStack {
                Text("menu")
                    .foregroundColor(.white)
                    .fontWeight(.light)
                Label("menu", systemImage: "info.circle.fill")
                    .imageScale(.large)
                    .tint(.white)
            }
        }
        .onTapGesture {
            play.tap()
        }
    }
}

struct MainToolbarView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            VStack {
                Text("Preview")
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color("top"), for: .navigationBar)
            .toolbar {
                MainToolbarView()
            }
        }
        .environmentObject(Navigator())
        .environmentObject(Play())
    }
}
