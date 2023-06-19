import SwiftUI

struct GameMenuView: View {
    let showTimer: Bool
    let debugPreviewTime: String
    private let menuItems: Set<MenuItemViewModel>

    init(showTimer: Bool = true, debugPreviewTime: String = "0:00") {
        self.showTimer = showTimer
        self.debugPreviewTime = debugPreviewTime
        menuItems = [.gameSolve]
    }

    var body: some View {
        MenuView(items: menuItems) {
            if showTimer {
                TimerMenuTitleView(seconds: debugPreviewTime)
            } else {
                MainMenuTitleView()
            }
        }
    }
}

struct GameMenuView_Previews: PreviewProvider {
    static var timerZeroSecs: some View {
        ZStack {
            Color("top")
            GameMenuView()
        }
        .frame(maxHeight: 44)
    }
    static var timerOneMinute: some View {
        ZStack {
            Color("top")
            GameMenuView(debugPreviewTime: "1:00")
        }
        .frame(maxHeight: 44)
    }
    static var timerOneMinuteDisabled: some View {
        ZStack {
            Color("top")
            GameMenuView(debugPreviewTime: "1:00")
        }
        .frame(maxHeight: 44)
        .disabled(true)
    }
    static var noTimer: some View {
        ZStack {
            Color("top")
            GameMenuView(showTimer: false)
        }
        .frame(maxHeight: 44)
    }
    static var noTimerDisabled: some View {
        ZStack {
            Color("top")
            GameMenuView(showTimer: false)
        }
        .frame(maxHeight: 44)
        .disabled(true)
    }
    static var previews: some View {
        Group {
            noTimer
                .previewDisplayName("noTimer")
            noTimerDisabled
                .previewDisplayName("noTimerDisabled")
            timerZeroSecs
                .previewDisplayName("timerZeroSecs")
            timerOneMinute
                .previewDisplayName("timerOneMinute")
            timerOneMinuteDisabled
                .previewDisplayName("timerOneMinuteDisabled")
        }
        .frame(width: 280)
    }
}
