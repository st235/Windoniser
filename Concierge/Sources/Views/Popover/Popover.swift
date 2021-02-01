import Foundation

class Popover: NSObject {
    
    private var popoverWindowController: PopoverWindowController?
    
    public var window: NSWindow? {
        return popoverWindowController?.window
    }
    
    public var isShown: Bool {
        return popoverWindowController?.isOpen ?? false
    }
    
    override init() {
        self.popoverWindowController = nil
        self.contentViewController = nil
        super.init()
    }
    
    var contentViewController: NSViewController? {
        didSet {
            guard let contentViewController = contentViewController else {
                return
            }
            
            popoverWindowController = PopoverWindowController(with: self, contentViewController: contentViewController)
        }
    }
    
    public func show(relativeTo view: NSView) {
        guard !isShown else { return }
        
        popoverWindowController?.show(relaiveTo: view)
    }

    public func dismiss() {
        guard isShown else { return }
        popoverWindowController?.dismiss()
    }
    
}
