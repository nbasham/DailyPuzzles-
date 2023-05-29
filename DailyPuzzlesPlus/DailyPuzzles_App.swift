//
//  DailyPuzzles_App.swift
//  DailyPuzzles+
//
//  Created by Norman Basham on 4/20/23.
//

import SwiftUI
//import CloudKit

@main
struct DailyPuzzles_App: App {
    @StateObject private var service = ContentService()
    @StateObject private var navigator = Navigator()
    @StateObject private var settings = Settings()
    @StateObject private var play = Play()
    @Environment(\.isPreview) var isPreview
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(navigator)
                .environmentObject(settings)
                .environmentObject(play)
                .environmentObject(service)
                .onAppear {
                    if isFirstTime {
                        firstTime()
                    }
// Do this for production
//                    CKRecord.subscribeToRecordUpdate(recordType: "FileAssetRecord") { (error) in
//                        print(error == nil ? "success" : error?.localizedDescription)
//                    }
                    guard !isPreview else { return }
                    //  Stop flashing white corners on rotation
                    if let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first {
                        window.rootViewController?.view.backgroundColor = UIColor(named: "background")
                    }
                }
        }
    }

    var isFirstTime: Bool {
        let key = "DailyPuzzles_App_firstTime"
        let obj = UserDefaults.standard.object(forKey: key)
        if obj == nil {
            UserDefaults.standard.set("obj", forKey: key)
            return true
        } else {
            return false
        }
    }

    private func firstTime() {
        print("First Time")
        CloudKitObserver.fetchCloudKitResources()
        CloudKitObserver.moveDefaultsToAppSupportDir()
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("applicationDidFinishLaunching")
        application.registerForRemoteNotifications()
        return true
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        CloudKitObserver.handleRemoteNotification(userInfo: userInfo)
    }
}
