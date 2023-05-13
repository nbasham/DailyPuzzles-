import SwiftUI

struct GameToolbarView: ToolbarContent {
    @EnvironmentObject private var coordinator: Coordinator

    var body: some ToolbarContent {
        Group {
            ToolbarItem(placement: .navigationBarLeading) {
                ZStack(alignment: .trailing) {
                    Button(action: {
                        coordinator.backSelected()
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
            Button("To do", action: {  } )
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
        .environmentObject(Coordinator())
    }
}
