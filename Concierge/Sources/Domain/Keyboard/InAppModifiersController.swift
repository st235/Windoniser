import Foundation

class InAppModifiersController {
    
    var onModifiersChangeListener: (([Key]) -> Void)? = nil
    
    private var lock = NSRecursiveLock()
    private var wasCalled: Bool = false
    private var monitor: Any?
 
    func listenUntilNewModifiersAppear(expectedCombination: Int) {
        lock.lock()
        wasCalled = false
        lock.unlock()
        
        self.monitor = NSEvent.addLocalMonitorForEvents(matching: [.flagsChanged, .keyDown]) { [weak self] event in
            guard let self = self else {
                return event
            }
            
            self.lock.lock()
            
            let keys = Key.extractKeys(flags: event.modifierFlags)
            
            if keys.count != expectedCombination {
                self.lock.unlock()
                return event
            }
            
            self.cancel()
            
            let listener = self.onModifiersChangeListener
            let shouldCallListener = !self.wasCalled
            self.wasCalled = true
            
            self.lock.unlock()
            
            if shouldCallListener {
                listener?(keys)
            }
            return event
        }
    }
    
    func cancel() {
        lock.lock()

        guard let monitor = self.monitor else {
            lock.unlock()
            return
        }
        
        NSEvent.removeMonitor(monitor)
        self.monitor = nil
        lock.unlock()
    }
    
}
