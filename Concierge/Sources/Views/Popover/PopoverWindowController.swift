import Foundation

class PopoverWindowController: NSWindowController, NSWindowDelegate {
    
    private var topOffset =  CGFloat(4)
    
    public private(set) var isOpen: Bool = false
    
    public private(set) var isAnimating: Bool = false
    
    public var appearance: NSAppearance = NSAppearance.current {
        didSet {
            self.window?.appearance = appearance
        }
    }
    
    private let popover: Popover
    
    init(with popover: Popover, contentViewController: NSViewController) {
        self.popover = popover
        let window = PopoverWindow.instantiate(appearance: appearance)
        super.init(window: window)
        window.delegate = self
        self.contentViewController = contentViewController
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func show(relaiveTo view: NSView) {
        guard !isAnimating else {
            return
        }
        
        updateWindowFrame(relateTo: view)
        
        showWindow(nil)
        isOpen = true
        window?.makeKey()
    }
    
    func dismiss() {
        guard !isAnimating else {
            return
        }
        
        window?.orderOut(self)
        window?.close()
        isOpen = false
    }
    
    private func updateWindowFrame(relateTo view: NSView) {
        guard let window = self.window as? PopoverWindow else {
            return
        }
        
        window.setFrame(calculateFrame(relateTo: view), display: true)
        window.appearance = appearance
    }
    
    private func calculateFrame(relateTo view: NSView) -> NSRect {
        let viewFrame = view.window?.frame ?? .zero
        
        guard let window = self.window as? PopoverWindow else {
            return .zero
        }
        
        let x = NSMinX(viewFrame) - NSWidth(window.frame) / 2 + NSWidth(viewFrame) / 2
        let y = NSMinY(viewFrame) - NSHeight(window.frame) - topOffset

        return NSMakeRect(x, y, NSWidth(window.frame), NSHeight(window.frame))
    }
    
}
