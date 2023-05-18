import SwiftUI

struct GameToolbarView: ToolbarContent {
    @EnvironmentObject private var navigator: Navigator

    var body: some ToolbarContent {
        Group {
            ToolbarItem(placement: .navigationBarLeading) {
                ZStack(alignment: .trailing) {
                    Button(action: {
                        navigator.pop()
                    }, label: {
                        HStack {
                            Label("back", systemImage: "chevron.left.circle.fill")
                                .imageScale(.large)
                                .tint(.white)
                            Text("back")
                                .foregroundColor(.white)
                                .fontWeight(.light)
                        }
                    })
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
//                if viewModel.showShareMenu {
//                    shareMenuView()
//                } else {
                    menuView()
//                }
            }
        }
    }

    private func menuView() -> some View {
        Menu {
            Button("Solve", action: {
                NotificationCenter.default.post(name: .gameSolve, object: nil) } )
        }
    label: {
        HStack {
            Text("menu")
                .foregroundColor(.white)
                .fontWeight(.light)
            Label("menu", systemImage: "info.circle.fill")
                .imageScale(.large)
                .tint(.white)
        }
    }
    }

    private func shareMenuView() -> some View {
        Button(action: { /*viewModel.showShare = true*/ }, label: {
            HStack {
                Text("share")
                    .foregroundColor(.white)
                    .fontWeight(.light)
                Image(systemName: "square.and.arrow.up.fill")
                    .imageScale(.large)
                    .tint(.white)
            }
        })
    }
}

struct GameToolbarView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            VStack {
                Text("Preview")
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(.green, for: .navigationBar)
            .toolbar {
                GameToolbarView()
            }
        }
        .environmentObject(Navigator())
    }
}

/*
 // Posting a notification
 NotificationCenter.default.post(name: .eventOccurred, object: nil)

 // Adding an observer
 NotificationCenter.default.addObserver(self, selector: #selector(someMethod), name: .eventOccurred, object: nil)

 // Or with SwiftUI's onReceive modifier
 .onReceive(NotificationCenter.default.publisher(for: .eventOccurred)) { _ in
 // Handle the notification
 }
 */
extension NSNotification.Name {
    static let gameHelp = NSNotification.Name("gameHelp")
    static let gameSolve = NSNotification.Name("gameSolve")
    static let gameStartAgain = NSNotification.Name("gameStartAgain")
    //  quotefalls
    static let autoAdvance = NSNotification.Name("autoAdvance")
    //  sudoku
    static let completeLastNumber = NSNotification.Name("completeLastNumber")
    static let placeMarkersTrailing = NSNotification.Name("placeMarkersTrailing")
    static let selectRowCol = NSNotification.Name("selectRowCol")
    static let undo = NSNotification.Name("undo")
    //  word search
    static let hideClues = NSNotification.Name("hideClues")
    //  debug
    static let almostSolveEvent = NSNotification.Name("almostSolveEvent")
}
