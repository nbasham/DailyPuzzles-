import SwiftUI

struct GameSolvedView: View {
    let game: GameDescriptor
    @State private var affirmation = ""
    @State private var appInstalled = false
    let affirmations = [ "Terrific", "Brilliant", "Fantastic", "Fabulous", "Exceptional", "Magnificent", "Outstanding", "Way to go", "Spectacular", "Congratulations", "Right on", "Great job", "Super job", "Fantastic", "You rock", "Superb", "Awesome", "First class" ]
    @EnvironmentObject private var appDelegate: AppDelegate
    private var roundApps: RoundApps? {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return appDelegate.roundApps
    }

    var body: some View {
        ZStack {
            game.color
            Color.black.opacity(0.02)
            VStack {
                Text(affirmation)
                    .font(.system(size: 19, weight: .semibold))
                .foregroundColor(.white)
                if appInstalled {
                    Button {
                        roundApps?.openApp(game)
                    } label: {
                        Text("Play More")
                    }
                } else {
                    Button {
                        roundApps?.openAppStore(game)
                    } label: {
                        Text("Get More")
                    }
                }
            }
        }
        .ignoresSafeArea()
        .onAppear {
            let index = Int(arc4random_uniform(UInt32(affirmations.count)))
            affirmation = affirmations[index] + "!"
            if (roundApps?.isAvailable(game) ?? false) {
                appInstalled = true
            } else {
                appInstalled = false
            }
        }
    }
}

struct GameSolvedView_Previews: PreviewProvider {
    static var previews: some View {
        GameSolvedView(game: .memory)
    }
}
