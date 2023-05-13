import SwiftUI

struct MainToolbarView: ToolbarContent {
    @EnvironmentObject private var coordinator: Coordinator

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
            Button("Help", action: { coordinator.mainHelpSelected() })
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
        .environmentObject(Coordinator())
    }
}
