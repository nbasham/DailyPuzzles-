import UIKit

//  https://useyourloaf.com/blog/querying-url-schemes-with-canopenurl/
class RoundApps {

    fileprivate var availability: Dictionary<GameDescriptor, Bool> = [.cryptogram: false, .crypto_families: false, .quotefalls: false, .sudoku: false, .word_search: false]

    init() {
        checkIfAppsInstalled()
        NotificationCenter.default.addObserver(self, selector: #selector(checkIfAppsInstalled), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    func isAvailable(_ descriptor: GameDescriptor) -> Bool {
        return availability[descriptor] ?? false
    }

    func openApp(_ descriptor: GameDescriptor) {
        if let url = descriptor.appUrl {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    func openAppStore(_ descriptor: GameDescriptor) {
        if let url = descriptor.appStoreUrl {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    fileprivate func isAppInstalled(_ descriptor: GameDescriptor) -> Bool {
        if let url = descriptor.appUrl {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }

    /// Checks to see if each Round app is installed and saves the results for future checks.
    @objc func checkIfAppsInstalled() {
        DispatchQueue.main.async { [unowned self = self] in
            for descriptor in GameDescriptor.all {
                let isInstalled = self.isAppInstalled(descriptor)
                print("\(descriptor.displayName) \(isInstalled)")
                self.availability[descriptor] = isInstalled
            }
        }
    }
}

