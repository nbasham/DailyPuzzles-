//
//  DailyPuzzles_App.swift
//  DailyPuzzles+
//
//  Created by Norman Basham on 4/20/23.
//

import SwiftUI

@main
struct DailyPuzzles_App: App {
    @StateObject private var service = ContentService()
    @StateObject private var navigator = Navigator()
    @StateObject private var settings = Settings()
    @StateObject private var play = Play()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(navigator)
                .environmentObject(settings)
                .environmentObject(play)
                .environmentObject(service)
                .onAppear {
                    //  Stop flashing white corners on rotation
                    if let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first {
                        window.rootViewController?.view.backgroundColor = UIColor(named: "background")
                    }
                }
        }
    }
}
