import SwiftUI

struct TimerMenuTitleView: View {
    @State var seconds = "0:00" // sets width so it doesn't jump at 0

    var body: some View {
        HStack {
            Text("\(seconds)")
                .foregroundColor(seconds == "0:00" ? .clear : .white)
                .monospacedDigit() // uses system font vs. monospace()
                .foregroundColor(.white)
                .fontWeight(.light)
                .fixedSize(horizontal: true, vertical: true)
           Image(systemName: "info.circle.fill")
                .imageScale(.large)
                .foregroundColor(.white)
                .tint(.white)
        }
        .onReceive(NotificationCenter.default.publisher(for: .gameTimer)) { notification in
            if let info = notification.object as? [String:Int] {
                let secs = info["secs"] ?? 0
                seconds = secs.timerValue
            }
        }
    }
}

struct TimerMenuTitleView_Previews: PreviewProvider {
    static var zeroSeconds: some View {
        ZStack {
            Color.top
            TimerMenuTitleView()
        }
        .frame(maxHeight: 44)
    }
    static var oneMinute: some View {
        ZStack {
            Color.top
            TimerMenuTitleView(seconds: "1:00")
        }
        .frame(maxHeight: 44)
    }
    static var previews: some View {
        zeroSeconds
        oneMinute
    }
}
