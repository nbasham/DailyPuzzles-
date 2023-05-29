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
    @Environment(\.isPreview) var isPreview
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var safeAreaInsets = EdgeInsets()

    var body: some Scene {
        WindowGroup {
            GeometryReader { geometry in
                ContentView()
                    .environmentObject(navigator)
                    .environmentObject(settings)
                    .environmentObject(play)
                    .environmentObject(service)
                    .environment(\.safeAreaDefault, $safeAreaInsets) // updates env var, including changes e.g. rotation
                    .onAppear {
                        if isFirstTime {
                            firstTime()
                        }
                        guard !isPreview else { return }
                        if let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first,
                        let view = window.rootViewController?.view {
                            //  Stop flashing white corners on rotation
                            view.backgroundColor = UIColor(named: "background")
                        }
                        safeAreaInsets = geometry.safeAreaInsets
                    }
                    .onChange(of: geometry.safeAreaInsets) { newInsets in
                        safeAreaInsets = newInsets
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
        application.registerForRemoteNotifications()
        return true
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        CloudKitObserver.handleRemoteNotification(userInfo: userInfo)
    }
}

struct SafeAreaDefault: EnvironmentKey {
    static var defaultValue: Binding<EdgeInsets> = .constant(EdgeInsets()) {
        didSet {
            print("defaultValue \(defaultValue)")
        }
    }
}

extension EnvironmentValues {
    var safeAreaDefault: Binding<EdgeInsets> {
        get { self[SafeAreaDefault.self] }
        set { self[SafeAreaDefault.self] = newValue }
    }
}
