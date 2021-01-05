import Foundation

class EventMonitor {
    
    public typealias Handler = () -> Void
    
    private var monitorRef: Any?
    private let mask: NSEvent.EventTypeMask
    var handler: Handler? = nil
    
    public init(mask: NSEvent.EventTypeMask) {
        self.mask = mask
    }
    
    public func start() {
        self.monitorRef = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: { [weak self] _ in
            self?.handler?()
        })
    }
    
    public func stop() {
        guard let monitor = monitorRef else {
            return
        }
        
        NSEvent.removeMonitor(monitor)
        monitorRef = nil
    }
    
}
