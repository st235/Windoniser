import Foundation

class PopoverWindow: NSPanel {
    
    private var childContentView: NSView?
    private var backgroundView: PopoverBackgroundView?
    
    static func instantiate(appearance: NSAppearance) -> PopoverWindow {
        return PopoverWindow(contentRect: .zero, styleMask: [.nonactivatingPanel], backing: .buffered, defer: true, appearance: appearance)
    }
    
    init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool, appearance: NSAppearance) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        
        isOpaque = false
        hasShadow = true
        level = .statusBar
        animationBehavior = .utilityWindow
        backgroundColor = .clear
        collectionBehavior = [.canJoinAllSpaces, .ignoresCycle]
        self.appearance = appearance
    }
    
    override var canBecomeKey: Bool {
        return true
    }
    
    override var contentView: NSView? {
        set {
            guard childContentView != newValue, let bounds = newValue?.bounds else { return }

            backgroundView = super.contentView as? PopoverBackgroundView
            if (backgroundView == nil) {
                backgroundView = PopoverBackgroundView(frame: bounds)
                backgroundView?.layer?.edgeAntialiasingMask = [.layerBottomEdge, .layerLeftEdge, .layerRightEdge, .layerTopEdge]
                super.contentView = backgroundView
            }

            if (self.childContentView != nil) {
                self.childContentView?.removeFromSuperview()
            }

            childContentView = newValue
//            childContentView?.translatesAutoresizingMaskIntoConstraints = false
            childContentView?.wantsLayer = true
            //TODO(st235): pass corner radius
            childContentView?.layer?.cornerRadius = 12
            childContentView?.layer?.masksToBounds = true
            childContentView?.layer?.edgeAntialiasingMask = [.layerBottomEdge, .layerLeftEdge, .layerRightEdge, .layerTopEdge]

            guard let userContentView = self.childContentView, let backgroundView = self.backgroundView else { return }
            backgroundView.addSubview(userContentView)
        }

        get {
            backgroundView
        }
    }
    
}
