import SwiftUI

struct MainHelpView: View {
    @Environment(\.dismiss) var dismiss
    let title: LocalizedStringKey = """
    Daily Puzzles+
    """
    let message: LocalizedStringKey = """
        **Daily Puzzles+** lets you solve a new cryptogram, crypto-families, memory, quotefalls, sudoku and word search puzzle every day. New, often topical puzzles become available every day at midnight. Puzzles are automatically saved so you can come and go at your leisure. Feel free to use the Contact Us menu item if you have any questions or suggestions.

        **Thank you!** We’re grateful that so many of you have stayed with us through the years - you’ve played a staggering 200 million puzzles! Our goal is to keep improving **Daily Puzzles+** so that you can enjoy it for many more years to come.

        Kelly, John, and Norman
        """

    var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {
                Color("background")
                    .ignoresSafeArea()
                VStack(alignment: .leading) {
                    Text("Welcome")
                        .font(.headline)
                        .padding(.vertical)
                    Text(message)
                        .padding(.bottom)
                    Spacer()
                    Text("Version 1.0")
                        .font(.caption)
                }
                .padding()
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color("top"), for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Daily Puzzles+")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Text("")
                            .foregroundColor(.white)
                            .fontWeight(.light)
                        Label("menu", systemImage: "x.circle.fill")
                            .imageScale(.large)
                            .foregroundColor(.white)
                    }
                    .onTapGesture {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct MainHelpView_Previews: PreviewProvider {
    static var previews: some View {
        MainHelpView()
    }
}

extension NSNotification.Name {
    static let help = NSNotification.Name("help")
}
