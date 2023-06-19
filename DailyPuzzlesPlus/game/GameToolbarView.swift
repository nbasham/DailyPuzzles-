import SwiftUI

struct GameToolbarView: ToolbarContent {
    @EnvironmentObject private var navigator: Navigator
    @EnvironmentObject private var settings: Settings
    @EnvironmentObject private var play: Play
    let showTimer: Bool
    @State private var menuItems: Set<MenuItemViewModel> = []
    @Binding var isGameSolved: Bool
    //  debugPreviewTime only exists to exercise Previews
    @State var debugPreviewTime: String = "0:00"

    var body: some ToolbarContent {
        Group {
            ToolbarItem(placement: .navigationBarLeading) {
                ZStack(alignment: .trailing) {
                    Button(action: {
                        play.tap()
                        NotificationCenter.default.post(name: .gameBackButton, object: nil)
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
                .onAppear {
                    MenuEvent.addMenuItem(.gameSolve)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                //                if viewModel.showShareMenu {
                //                    shareMenuView()
                //                } else {
                menuView(isGameSolved: isGameSolved)
                //                }
            }
        }
    }

    private func menuView(isGameSolved: Bool) -> some View {
        GameMenuView(showTimer: showTimer, debugPreviewTime: debugPreviewTime)
        .opacity(isGameSolved ? 0.5 : 1)
        .disabled(isGameSolved)
   }

    private func shareButton() -> some View {
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
    struct WrapperView<Content: View>: View {
        @ViewBuilder var content: Content
        var body: some View {
            NavigationStack {
                content
            }
            .environmentObject(Navigator())
            .environmentObject(Settings())
            .environmentObject(Play())
        }
    }
    static var notSolvedWithTimerAtZero: some View {
        WrapperView {
            VStack {
                Text("Preview")
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color.top, for: .navigationBar)
            .toolbar {
                GameToolbarView(showTimer: true, isGameSolved: .constant(false))
            }
        }
    }
    static var notSolvedWithTimerOneMinute: some View {
        WrapperView {
            VStack {
                Text("Preview")
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color.top, for: .navigationBar)
            .toolbar {
                GameToolbarView(showTimer: true, isGameSolved: .constant(false), debugPreviewTime: "1:00")
            }
        }
    }
    static var notSolvedNoTimer: some View {
        WrapperView {
            VStack {
                Text("Preview")
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color.top, for: .navigationBar)
            .toolbar {
                GameToolbarView(showTimer: false, isGameSolved: .constant(false))
            }
        }
    }
    static var solvedWithTimerAtZero: some View {
        WrapperView {
            VStack {
                Text("Preview")
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color.top, for: .navigationBar)
            .toolbar {
                GameToolbarView(showTimer: true, isGameSolved: .constant(true))
            }
        }
    }
    static var solvedWithTimerOneMinute: some View {
        WrapperView {
            VStack {
                Text("Preview")
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color.top, for: .navigationBar)
            .toolbar {
                GameToolbarView(showTimer: true, isGameSolved: .constant(true), debugPreviewTime: "1:00")
            }
        }
    }
    static var solvedNoTimer: some View {
        WrapperView {
            VStack {
                Text("Preview")
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color.top, for: .navigationBar)
            .toolbar {
                GameToolbarView(showTimer: false, isGameSolved: .constant(true))
            }
        }
    }
    static var previews: some View {
        notSolvedWithTimerAtZero
            .previewDisplayName("notSolvedWithTimerAtZero")
        notSolvedWithTimerOneMinute
            .previewDisplayName("notSolvedWithTimerOneMinute")
        notSolvedNoTimer
            .previewDisplayName("notSolvedNoTimer")
        solvedWithTimerAtZero
            .previewDisplayName("solvedWithTimerAtZero")
        solvedWithTimerOneMinute
            .previewDisplayName("solvedWithTimerOneMinute")
        solvedNoTimer
            .previewDisplayName("solvedNoTimer")
    }
}

