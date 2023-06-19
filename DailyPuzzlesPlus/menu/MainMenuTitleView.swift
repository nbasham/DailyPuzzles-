import SwiftUI

struct MainMenuTitleView: View {
    var body: some View{
        HStack {
            Text("menu")
                .foregroundColor(.white)
                .fontWeight(.light)
            Image(systemName: "info.circle.fill")
                .imageScale(.large)
                .foregroundColor(.white)
                .tint(.white)
        }
    }
}

struct MainMenuTitleView_Previews: PreviewProvider {
    static var main: some View {
        ZStack {
            Color("top")
            Menu {
            } label: {
                MainMenuTitleView()
            }
        }
        .frame(maxHeight: 44)
    }
    static var previews: some View {
        main
            .previewDisplayName("main")
    }
}
