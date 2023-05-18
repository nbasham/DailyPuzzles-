//
//  ContentView.swift
//  DailyPuzzles+
//
//  Created by Norman Basham on 4/20/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var navigator: Navigator

    var body: some View {
        NavigationStack(path: $navigator.path) {
            MainView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Navigator())
    }
}
