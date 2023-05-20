import SwiftUI

class Settings: ObservableObject {
    // Get app storage and published behavior!
    @AppStorage("timerOn") var timerOn: Bool = true {
        willSet {
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }
}

