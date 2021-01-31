import Foundation
import AppKit

protocol _LayoutPreviewViewDelegate: AnyObject {
    
    func onPreviewSelected(preview: LayoutPreviewView.LayoutPreview, payload: Any?)
    
}

class LayoutPreviewView: NSView {

    typealias LayoutPreview = NSRect
    typealias Delegate = _LayoutPreviewViewDelegate
    
    private static let filteringOptions = [NSPasteboard.ReadingOptionKey.urlReadingContentsConformToTypes:[NSPasteboard.PasteboardType.windowPid]]

    private let projectionBounds = NSRect(x: 0, y: 0, width: 1, height: 1)
    
    private var layoutPreviews: [LayoutPreview] = []
    private var projectedPreviews: [LayoutPreview] = []
    private var highlightedPreivew: LayoutPreview? = nil
    
    weak var delegate: Delegate? = nil
    
    var inactiveColor: NSColor = .blue {
        didSet {
            needsDisplay = true
        }
    }
    
    var highlightColor: NSColor = .red {
        didSet {
            needsDisplay = true
        }
    }
    
    var backgroundColor: NSColor? {
        get {
            guard let color = layer?.backgroundColor else {
                return nil
            }
            
            return NSColor(cgColor: color)
        }
        set {
            wantsLayer = true
            layer?.backgroundColor = newValue?.cgColor
            layer?.masksToBounds = true
            layer?.cornerRadius = roundRadius
        }
    }
    
    private var roundRadius: CGFloat = 4 {
        didSet {
            needsDisplay = true
        }
    }
    
    var paddingBetweenPreviews: CGFloat = 4 {
        didSet {
            updateLayoutProjections()
            needsDisplay = true
        }
    }
    
    var isReceivingDrag = false {
      didSet {
        needsDisplay = true
      }
    }
    
    private func updateLayoutProjections() {
        projectedPreviews.removeAll()
        
        for preview in projectedPreviews {
            projectedPreviews.append(getLayoutProjection(layoutPreview: preview, padding: paddingBetweenPreviews))
        }
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        let allow = shouldAllowDrag(sender)
        isReceivingDrag = allow
        return allow ? .copy : NSDragOperation()
    }
    
    override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation {
        let mousePosition = sender.draggingLocation
        let pointerPosition = convert(mousePosition, from: nil)
        
        highlightedPreivew = findHighlightedProjection(position: pointerPosition)
    
        isReceivingDrag = true
        return .copy
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
      highlightedPreivew = nil
      isReceivingDrag = false
    }
    
    private func shouldAllowDrag(_ draggingInfo: NSDraggingInfo) -> Bool {
      let pasteBoard = draggingInfo.draggingPasteboard
      if pasteBoard.canReadObject(forClasses: [WindowPasteboard.self], options: LayoutPreviewView.filteringOptions) {
        return true
      }
      return false
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        isReceivingDrag = false
        highlightedPreivew = nil
        
        let pasteBoard = sender.draggingPasteboard
        let point = convert(sender.draggingLocation, from: nil)
        let projection = findHighlightedProjection(position: point)
                
        if let pids = pasteBoard.readObjects(forClasses: [WindowPasteboard.self], options: LayoutPreviewView.filteringOptions) as? [WindowPasteboard],
           let projection = projection,
           pids.count > 0 {
            delegate?.onPreviewSelected(preview: layoutPreviews[projectedPreviews.firstIndex(of: projection)!], payload: pids)
          return true
        }
        
        return false
    }
    
    func setShadow(withOpacity opacity: Float, andRadius radius: CGFloat) {
        let shadow = NSShadow()
        shadow.shadowColor = NSColor.darkGray
        shadow.shadowOffset = NSMakeSize(0, 0)
        shadow.shadowBlurRadius = radius
        
        wantsLayer = true
        self.shadow = shadow
    }
    
    func addLayoutPreview(layoutPreview: LayoutPreview) {
        layoutPreviews.append(layoutPreview)
        projectedPreviews.append(getLayoutProjection(layoutPreview: layoutPreview, padding: paddingBetweenPreviews))
        needsDisplay = true
    }
    
    func clear() {
        layoutPreviews.removeAll()
        projectedPreviews.removeAll()
        needsDisplay = true
    }
    
    override func draw(_ dirtyRect: NSRect) {
        for projection in projectedPreviews {
            if projection == highlightedPreivew {
                continue
            }
            
            drawInactiveScreen(projection: projection, color: inactiveColor)
        }
        
        if let highlightedPreivew = highlightedPreivew {
            drawActiveScreen(projection: highlightedPreivew, color: highlightColor)
        }
    }
    
    private func drawInactiveScreen(projection: LayoutPreview, color: NSColor) {
        color.set()
        let path = NSBezierPath.init(roundedRect: projection, xRadius: roundRadius, yRadius: roundRadius)
        
        path.lineWidth = 2.0
        let dashes: [CGFloat] = [16.0, 8.0]
        path.setLineDash(dashes, count: dashes.count, phase: 0.0)
        path.stroke()
    }
    
    private func drawActiveScreen(projection: LayoutPreview, color: NSColor) {
        color.set()
        let path = NSBezierPath.init(roundedRect: projection, xRadius: roundRadius, yRadius: roundRadius)
        
        path.fill()
    }
    
    private func findHighlightedProjection(position: NSPoint) -> LayoutPreview? {
        for prjection in projectedPreviews {
            if prjection.contains(position) {
                return prjection
            }
        }
        
        return nil
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
