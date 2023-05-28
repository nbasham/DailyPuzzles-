import SwiftUI

struct MainHelpView: View {
    @Environment(\.dismiss) var dismiss
    let title: LocalizedStringKey = """
    Daily Puzzles+
    """
    let message: LocalizedStringKey = """
        We're excited to introduce you to Daily Puzzles Plus, our premium subscription-based version of the much-loved Daily Puzzles app you've enjoyed for the last decade. This enhanced version comes packed with a host of exciting new features and improvements, all designed to enrich your puzzle-solving experience. In addition to the daily cryptogram, crypto-families, memory, quotefalls, sudoku, and word search puzzles you're familiar with, Daily Puzzles Plus brings a variety of new games to challenge your brain. Additionally, we've refined your favorites with a fresh coat of interactive polish. Now, for the first time, you can choose the level of difficulty for your puzzles, letting you tailor your gaming experience to your mood or desired challenge. With Daily Puzzles Plus, your favorite puzzles will be ready and waiting for you at midnight, with all progress automatically saved, so you can dive in and out at your convenience. Join us on Daily Puzzles Plus, and elevate your daily puzzling to the next level!

        **Thank you!** We’re grateful that so many of you have stayed with us through the years - you’ve played a staggering 200 million puzzles! Our goal is to keep improving **Daily Puzzles+** so that you can enjoy it for many more years to come.

        Kelly, John, and Norman
        """

    var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {
                Color("background")
                    .ignoresSafeArea()
                ScrollView {
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
    static let contact = NSNotification.Name("contact")
    static let help = NSNotification.Name("help")
}
