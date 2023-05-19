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

extension UserDefaults {
    func object<T: Decodable>(forKey key: String) -> T? {
        if let data = self.object(forKey: key) as? Data {
            let decoder = JSONDecoder()
            if let obj = try? decoder.decode(T.self, from: data) {
                return obj
            }
        }
        return nil
    }

    func set(value: Encodable, forKey key: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(value) {
            self.set(encoded, forKey: key)
        }
    }
}
