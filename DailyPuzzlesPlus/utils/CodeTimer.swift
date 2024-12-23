import Foundation

/*  https://gist.github.com/nbasham/d5bb9671e8e74abb1f8387575d8c8e46
 let timer = CodeTimer()
 timer.log("Time elapsed:") // Time elapsed: 0.380 second(s).
 */
final class CodeTimer {
    var startTime: CFAbsoluteTime = 0

    public init() {
        start()
    }

    public func start() {
        startTime = CFAbsoluteTimeGetCurrent()
    }

    public func log(_ message: String) {
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        let s = String(format: "%.5f", timeElapsed)
        print("\(message) \(s) second(s).")
    }

}
