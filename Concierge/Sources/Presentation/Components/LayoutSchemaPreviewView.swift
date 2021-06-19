import Foundation
import AppKit

class LayoutSchemaPreviewView: NSView {

    typealias LayoutPreview = NSRect
    
    typealias LayoutSeparator = Vector2

    private var projectionBounds = NSRect(x: 0, y: 0, width: 1.0, height: 1.0)
    
    private var separators: [LayoutSeparator] = []
    
    private var projectedSeparators: [LayoutSeparator] = []
    
    private var roundRadius = CGFloat(3)
    
    var highlightColor: NSColor = NSColor.white.withAlphaComponent(1.0) {
        didSet {
            needsDisplay = true
        }
    }
    
    var horizontalPadding: Double = 0 {
        didSet {
            projectionBounds = NSRect(x: horizontalPadding, y: verticalPadding, width: 1.0 - horizontalPadding * 2, height: 1.0 - verticalPadding * 2)
            needsDisplay = true
        }
    }
    
    var verticalPadding: Double = 0 {
        didSet {
            projectionBounds = NSRect(x: horizontalPadding, y: verticalPadding, width: 1.0 - horizontalPadding * 2, height: 1.0 - verticalPadding * 2)
            needsDisplay = true
        }
    }
    
    var gridWidth: CGFloat = 2.0 {
        didSet {
            needsDisplay = true
        }
    }
    
    var borderWidth: CGFloat = 2.5 {
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
        self.verticalPadding = 0.15
        self.horizontalPadding = 0.075
        self.borderWidth = 2.5
        self.gridWidth = 2.0
        
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
        
        path.lineWidth = borderWidth
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
        path.lineWidth = gridWidth
        
        highlightColor.setStroke()
        path.stroke()
    }
    
    private func getSeparatorProjection(separator: LayoutSeparator) -> LayoutSeparator {
        return LayoutSeparator(start: Point(x: Float(separator.x.x * bounds.width * projectionBounds.width + bounds.width * projectionBounds.minX),
                                            y: Float(separator.x.y * bounds.height * projectionBounds.height + bounds.height * projectionBounds.minY)),
                               finish: Point(x: Float(separator.y.x * bounds.width * projectionBounds.width + bounds.width * projectionBounds.minX),
                                             y: Float(separator.y.y * bounds.height * projectionBounds.height + bounds.height * projectionBounds.minY)))
    }

}
