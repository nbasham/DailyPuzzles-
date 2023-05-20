import Foundation

extension Date {
    static var yyddmm: String {
        Date().yyddmm
    }

    var yyddmm: String {
        let dc = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let day = String(format: "%02d", dc.day!)
        let month = String(format: "%02d", dc.month!)
        let year = String(format: "%02d", dc.year!)
        return "\(year)\(month)\(day)"
    }

    static var ddmm: String {
        Date().ddmm
    }

    var ddmm: String {
        let dc = Calendar.current.dateComponents([.month, .day], from: self)
        let day = String(format: "%02d", dc.day!)
        let month = String(format: "%02d", dc.month!)
        return "\(month)\(day)"
    }
}

public extension Int {
    /// 96.timerValue, yeilds "1:36"
    var timerValue: String {
        let hours = self / 3600
        let minutes = (self % 3600) / 60
        let seconds = (self % 3600) % 60
        let timeStr = hours == 0 ? "\(minutes):\(String(format: "%02d", seconds))" : "\(hours):\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))"
        return timeStr
    }
}
