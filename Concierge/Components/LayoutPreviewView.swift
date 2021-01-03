import Foundation
import AppKit

class LayoutPreviewView: NSView {
    
    typealias LayoutPreview = NSRect
    
    private let projectionBounds = NSRect(x: 0, y: 0, width: 1, height: 1)
    
    private var layoutPreviews: [LayoutPreview] = []
    
    private var inactiveLayoutPreviewColor: NSColor = .blue
    private var activeLayoutPreviewColor: NSColor = .red
    
    private var roundRadius: CGFloat = 4
    private var paddingBetweenPreviews: CGFloat = 4
    
    func addLayoutPreview(layoutPreview: LayoutPreview) {
        layoutPreviews.append(layoutPreview)
        setNeedsDisplay(bounds)
    }
    
    func clear() {
        layoutPreviews.removeAll()
        setNeedsDisplay(bounds)
    }
    
    func setBackgroundColor(backgroundColor: CGColor) {
        wantsLayer = true
        layer?.backgroundColor = backgroundColor
        layer?.masksToBounds = true
        layer?.cornerRadius = roundRadius
    }
    
    override func draw(_ dirtyRect: NSRect) {
        for layoutPreview in layoutPreviews {
            drawScreen(layoutPreview: layoutPreview)
        }
    }
    
    private func drawScreen(layoutPreview: LayoutPreview) {
        let projection = getLayoutProjection(layoutPreview: layoutPreview, padding: paddingBetweenPreviews)
        let path: NSBezierPath = NSBezierPath.init(roundedRect: projection, xRadius: roundRadius, yRadius: roundRadius)
        
        inactiveLayoutPreviewColor.setFill()
        path.fill()
    }
    
    private func getLayoutProjection(layoutPreview: LayoutPreview, padding: CGFloat) -> NSRect {
        let projectedXScale = layoutPreview.width / projectionBounds.width
        let projectedYScale = layoutPreview.height / projectionBounds.height
        
        let projectedWidth = projectedXScale * bounds.width - 2 * padding
        let projectedHeight = projectedYScale * bounds.height - 2 * padding
        
        let projectedX = layoutPreview.minX * (bounds.width / projectionBounds.width) + padding
        let projectedY = layoutPreview.minY * (bounds.height / projectionBounds.height) + padding
        
        return NSRect(x: projectedX, y: projectedY, width: projectedWidth, height: projectedHeight)
    }
}
