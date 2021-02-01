import Foundation

class PopoverBackgroundView: NSView {
    
    var backgroundColor: NSColor = .systemGreen
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        wantsLayer = true
        layer?.cornerRadius = 12
        layer?.masksToBounds = true
        
        let visualEffect = NSVisualEffectView()
        visualEffect.blendingMode = NSVisualEffectView.BlendingMode.behindWindow
        visualEffect.material = .menu

        addSubview(visualEffect, positioned: .below, relativeTo: self)

        visualEffect.translatesAutoresizingMaskIntoConstraints = false
        visualEffect.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        visualEffect.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        visualEffect.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        visualEffect.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("Coder init not implemented, sorry")
    }

    override var frame: NSRect {
        didSet {
            setNeedsDisplay(frame)
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
//        backgroundColor.setFill()
//        bounds.fill()
    }
    
    override var allowsVibrancy: Bool {
        return true
    }
    
}
