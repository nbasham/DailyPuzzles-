import Foundation

protocol SecondsTimerListener {
    func update(elapsedSeconds: Int)
}

class SecondsTimer {
    private var secondUpdateHandler: ((Int) -> Void)?
    private var timer: Timer?
    private var timerPaused = true
    private var seconds = 0
 
    func start(initialSeconds: Int = 0, secondUpdateHandler: @escaping (Int) -> Void) {
        self.secondUpdateHandler = secondUpdateHandler
        seconds = initialSeconds
        timer?.invalidate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateSeconds), userInfo: nil, repeats: true)
            self.timerPaused = false
        }
    }

    func pause() { timerPaused = true }
    func resume() { timerPaused = false }
    func end() { timer?.invalidate() }

    @objc func updateSeconds() {
        guard !timerPaused else { return }
        seconds += 1
        secondUpdateHandler?(seconds)
    }

}
