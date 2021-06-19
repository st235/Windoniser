import Foundation

class CustomBackgroundView: NSView {
    
    var backgroundColor: NSColor = .white {
        didSet {
            needsDisplay = true
        }
    }
    
    var cornerRadius: CGFloat = 12.0 {
        didSet {
            needsDisplay = true
        }
    }
    
    init() {
        super.init(frame: .zero)
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        let path = NSBezierPath(roundedRect: bounds, xRadius: cornerRadius, yRadius: cornerRadius)
        
        backgroundColor.setFill()
        path.fill()
    }
    
}
