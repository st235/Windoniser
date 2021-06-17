import Foundation

class InAppModifiersController {
    
    var onHotKeyChanged: (([Key]) -> Void)? = nil
    
    private var lock = NSRecursiveLock()
    private var monitor: Any?
    private var recordedKeys: [Key] = []
 
    func recordKeys() {
        self.monitor = NSEvent.addLocalMonitorForEvents(matching: [.flagsChanged, .keyDown]) { [weak self] event in
            guard let self = self else {
                return event
            }
            
            self.lock.lock()
            
            var shouldFireListener = false
            let keys = Key.extractKeys(flags: event.modifierFlags)
            
            if keys.count > self.recordedKeys.count {
                self.recordedKeys = keys
                shouldFireListener = true
            }
            
            self.lock.unlock()
            
            if shouldFireListener {
                self.onHotKeyChanged?(keys)
            }
            
            return event
        }
    }
    
    func getRecordedKeys() -> [Key] {
        lock.lock()
        let keys = recordedKeys
        lock.unlock()
        return keys
    }
    
    func cancel() {
        lock.lock()

        guard let monitor = self.monitor else {
            lock.unlock()
            return
        }
        
        NSEvent.removeMonitor(monitor)
        self.monitor = nil
        self.recordedKeys = []
        lock.unlock()
    }
    
}
