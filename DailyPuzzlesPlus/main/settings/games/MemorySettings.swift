import SwiftUI

class MemorySettings {
    enum ImageType: Int {
        case clipArt = 0, emoji = 1, symbol = 2
    }
    private static let key = "MemorySettings_ImageType"
    static var imageType: ImageType {
        get {
            let i = UserDefaults.standard.value(forKey: key) as? Int ?? 0
            return ImageType(rawValue: i)!
        }
        set {
            UserDefaults.standard.setValue(newValue.rawValue, forKey: key)
        }
    }
}
