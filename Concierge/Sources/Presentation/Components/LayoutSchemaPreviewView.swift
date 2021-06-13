import Foundation
import AppKit

class LayoutSchemaPreviewView: NSView {

    typealias LayoutPreview = NSRect
    
    typealias LayoutSeparator = Vector2

    private let projectionBounds = NSRect(x: 0.1, y: 0.15, width: 0.8, height: 0.7)
    
    private var separators: [LayoutSeparator] = []
    
    private var projectedSeparators: [LayoutSeparator] = []
    
    private var roundRadius = CGFloat(3)
    
    var highlightColor: NSColor = NSColor.white.withAlphaComponent(1.0) {
        didSet {
            needsDisplay = true
        }
    }
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        wantsLayer = true
        layer?.cornerRadius = roundRadius
        layer?.masksToBounds = true
    }
    
    private func updateLayoutProjections() {
        projectedSeparators.removeAll()
        
        for separator in separators {
            projectedSeparators.append(getSeparatorProjection(separator: separator))
        }
    }
    
    func addLayoutPreviews(layoutSeparators: [LayoutSeparator]) {
        self.separators = layoutSeparators
        
        updateLayoutProjections()
        
        needsDisplay = true
    }
    
    func clear() {
        separators.removeAll()
        projectedSeparators.removeAll()
        needsDisplay = true
    }
    
    override func draw(_ dirtyRect: NSRect) {
        updateLayoutProjections()
        
        let path = NSBezierPath.init(roundedRect: NSRect(x: projectionBounds.minX * bounds.width + bounds.minX, y: projectionBounds.minY * bounds.height + bounds.minX, width: projectionBounds.width * bounds.width, height: bounds.height * projectionBounds.height), xRadius: roundRadius, yRadius: roundRadius)
        
        path.lineWidth = 2.5
        highlightColor.setStroke()
        path.stroke()
        
        for separator in projectedSeparators {
            drawSeparator(separator: separator)
        }
    }
    
    private func drawSeparator(separator: Vector2) {
        let path = NSBezierPath.init()
        path.move(to: separator.x)
        path.line(to: separator.y)
        path.lineWidth = 2.0
        
        highlightColor.setStroke()
        path.stroke()
    }
    
    private func getSeparatorProjection(separator: LayoutSeparator) -> LayoutSeparator {
        return LayoutSeparator(x: NSPoint(x: separator.x.x * bounds.width * projectionBounds.width + bounds.width * projectionBounds.minX,
                                          y: separator.x.y * bounds.height * projectionBounds.height + bounds.height * projectionBounds.minY),
                               y: NSPoint(x: separator.y.x * bounds.width * projectionBounds.width + bounds.width * projectionBounds.minX,
                                          y: separator.y.y * bounds.height * projectionBounds.height + bounds.height * projectionBounds.minY))
    }

}
