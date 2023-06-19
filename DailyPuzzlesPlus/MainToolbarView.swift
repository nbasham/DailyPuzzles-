import SwiftUI

//  DOESN'T WORK IN SIMULATOR, be sure to import MessageUI into the Xcode project
struct MainToolbarView: ToolbarContent {
    @EnvironmentObject private var navigator: Navigator
    @EnvironmentObject private var play: Play
    @EnvironmentObject private var viewModel: MainViewModel
    @State var overMinXMargin: CGFloat = 0

    var body: some ToolbarContent {
        Group {
            ToolbarItem(placement: .navigationBarLeading) {
                ZStack(alignment: .trailing) {
                    logoView
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                MainMenuView()
            }
        }
    }

    private var logoView: some View {
        HStack(spacing: 2) {
            Spacer(minLength: 39)
            Text("Daily")
                .fontWeight(.light)
            Text("Puzzles")
                .fontWeight(.heavy)
            Spacer()
        }
        .font(.system(size: 19))
        .foregroundColor(.white)
        .fixedSize(horizontal: true, vertical: true)
        .frame(width: 148 - overMinXMargin)
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

struct MenuItem: View {
    let name: String
    let notificationName: NSNotification.Name
    @EnvironmentObject private var play: Play

    var body: some View {
        Button(name, action: {
            NotificationCenter.default.post(name: notificationName, object: nil)
            play.tap()
        } )
    }
}
