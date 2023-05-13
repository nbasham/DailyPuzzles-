import SwiftUI

@MainActor
class Coordinator: ObservableObject {
    @Published var path = NavigationPath()
    @Published var sheet: Coordinator.Path?
    @Published var fullscreen: Coordinator.Path?

    init() {
        print("Coordinator init'd")
    }

    deinit {
        print("Coordinator deinit'd")
    }

    @ViewBuilder
    func navigate(to path: Coordinator.Path) -> some View {
        switch path.id {
            case "help":
                HelpView()
            default:
                GameHostView(viewModel: GameHostViewModel(game: GameDescriptor(rawValue: path.id)!))
        }
    }

    func handleRotation(_ orientation: UIDeviceOrientation) {
        //  for some reason an occasional .unknow is received
        guard orientation != .unknown else { return }
    }

    func backSelected() {
        path.removeLast()
    }

    func gameSelected(_ game: GameDescriptor) {
        path.append(game.id.path)
    }

    func mainHelpSelected() {
        sheet = "help".path
    }

    func mainHelpDismissSelected() {
        sheet = nil
    }
}

extension Coordinator {
    struct Path: Identifiable, Hashable {
        let id: String
    }
}

extension String {
    var path: Coordinator.Path { Coordinator.Path(id: self) }
}


struct HelpView: View {
    @EnvironmentObject private var coordinator: Coordinator

    var body: some View {
        Button("Dismiss Me") {
            coordinator.mainHelpDismissSelected()
        }
    }
}
