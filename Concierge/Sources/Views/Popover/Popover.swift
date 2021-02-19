import Foundation

class Popover: NSObject {
    
    public var window: NSWindow? {
        return popoverWindowController?.window
    }
    
    public var isShown: Bool {
        return popoverWindowController?.isOpen ?? false
    }
    
    public var isAutoCancellable: Bool = false
    
    public var appearance: NSAppearance {
        didSet {
            popoverWindowController?.appearance = appearance
        }
    }
    
    private var popoverWindowController: PopoverWindowController?
    private let eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown])
    
    init(isAutoCancellable: Bool = false) {
        self.popoverWindowController = nil
        self.contentViewController = nil
        self.appearance = NSAppearance.current
        self.isAutoCancellable = isAutoCancellable
        super.init()
        
        self.eventMonitor.handler = { [weak self] in
            if isAutoCancellable {
                self?.dismiss()
            }
        }
    }
    
    var contentViewController: NSViewController? {
        didSet {
            guard let contentViewController = contentViewController else {
                return
            }
            
            popoverWindowController = PopoverWindowController(with: self, contentViewController: contentViewController)
            popoverWindowController?.appearance = appearance
        }
    }
    
    public func show(relativeTo view: NSView) {
        guard !isShown else { return }
        
        eventMonitor.start()
        popoverWindowController?.show(relaiveTo: view)
    }

    public func dismiss() {
        guard isShown else { return }
        
        eventMonitor.stop()
        popoverWindowController?.dismiss()
    }
    
}
