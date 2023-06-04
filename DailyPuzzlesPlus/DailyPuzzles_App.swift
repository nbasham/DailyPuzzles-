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
    @State private var isPortrait = UIDevice.current.orientation == .portrait

    var body: some Scene {
        WindowGroup {
            GeometryReader { geometry in
                ContentView()
                    .preferredColorScheme(settings.darkMode ? .dark : nil)
                    .environmentObject(navigator)
                    .environmentObject(settings)
                    .environmentObject(play)
                    .environmentObject(service)
                    .environment(\.portraitDefault, $isPortrait) // updates env var, including changes e.g. rotation
                    .environment(\.safeAreaDefault, $safeAreaInsets) // updates env var, including changes e.g. rotation
                    .onAppear {
                        if isFirstTime {
                            firstTime()
                        }
                        // Since env vars can only be accessed without warning from View, we set a flag that view models or any other ObservableObject can use
                        UserDefaults.standard.set(false, forKey: "isPreview")
                        UserDefaults.standard.set(isPreview, forKey: "isPreview")
                        guard !isPreview else { return }
                        if let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first,
                        let view = window.rootViewController?.view {
                            //  Stop flashing white corners on rotation
                            view.backgroundColor = UIColor(named: "background")
                        }
                        safeAreaInsets = geometry.safeAreaInsets
                        isPortrait = geometry.size.height > geometry.size.width
                    }
                    .onChange(of: geometry.safeAreaInsets) { newInsets in
                        safeAreaInsets = newInsets
                    }
                    .onChange(of: geometry.size) { size in
//                        isPortrait = UIDevice.current.orientation == .portrait
                        isPortrait = size.height > size.width
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
        UserDefaults.standard.set(Date(), forKey: "dailypuzzlesplus_first_day")
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

struct PortraitDefault: EnvironmentKey {
//    static var defaultValue: Binding<Bool> = .constant(UIApplication.shared.statusBarOrientation == .portrait)
    static var defaultValue: Binding<Bool> = .constant(UIDevice.current.orientation == .portrait)
}

extension EnvironmentValues {
    var portraitDefault: Binding<Bool> {
        get { self[PortraitDefault.self] }
        set { self[PortraitDefault.self] = newValue }
    }
}

struct SafeAreaDefault: EnvironmentKey {
    static var defaultValue: Binding<EdgeInsets> = .constant(EdgeInsets())
}

extension EnvironmentValues {
    var safeAreaDefault: Binding<EdgeInsets> {
        get { self[SafeAreaDefault.self] }
        set { self[SafeAreaDefault.self] = newValue }
    }
}
