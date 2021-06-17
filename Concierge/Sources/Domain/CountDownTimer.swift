import Foundation

class CountDownTimer {
    
    enum State {
        case idle
        case running
    }
    
    var onTickListener: ((Double) -> Void)? = nil
    var onFinishListener: (() -> Void)? = nil
    
    private let lock = NSRecursiveLock()
    
    private var state: State = .idle
    
    private var timer: Double = 0
    private var tick: Double = 0
    
    private var instance: Timer? = nil
    
    func start(interval: Double, tickInterval: Double) {
        lock.lock()
        
        if state != .idle {
            fatalError()
        }
        
        self.timer = interval
        self.tick = tickInterval
        self.state = .running
        
        instance = Timer.scheduledTimer(withTimeInterval: tick, repeats: true, block: { [weak self] _ in
            self?.onTimerFinished()
        })
        
        lock.unlock()
    }
    
    private func onTimerFinished() {
        lock.lock()
        
        self.timer -= tick
        print(timer)
        
        var shouldFinish = false
        let leftSeconds = max(0, timer)
        
        if self.timer <= 0  {
            shouldFinish = true
            self.cancel()
        }
        
        lock.unlock()
        
        if shouldFinish {
            onFinishListener?()
        } else {
            onTickListener?(leftSeconds)
        }
    }
    
    func cancel() {
        lock.lock()
        
        if state == .idle {
            lock.unlock()
            return
        }
        
        self.state = .idle
        self.tick = 0
        self.timer = 0
        
        if self.instance != nil {
            self.instance!.invalidate()
        }
        
        lock.unlock()
    }
    
}
