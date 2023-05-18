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
                .onAppear {
                    //  Stop flashing white corners on rotation
                    if let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first {
                        window.rootViewController?.view.backgroundColor = UIColor(named: "background")
                    }
                }
        }
    }
}
