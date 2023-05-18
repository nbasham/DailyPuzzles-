//
//  DailyPuzzles_App.swift
//  DailyPuzzles+
//
//  Created by Norman Basham on 4/20/23.
//

import SwiftUI

@main
struct DailyPuzzles_App: App {
    @StateObject private var navigator = Navigator()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(navigator)
        }
    }
}
