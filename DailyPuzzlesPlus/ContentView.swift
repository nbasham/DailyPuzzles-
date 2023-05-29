//
//  ContentView.swift
//  DailyPuzzles+
//
//  Created by Norman Basham on 4/20/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appDelegate: AppDelegate
    @EnvironmentObject private var navigator: Navigator

    var body: some View {
        NavigationStack(path: $navigator.path) {
            MainView(viewModel: MainViewModel())
        }
        .statusBarHidden()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Navigator())
    }
}
