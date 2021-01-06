import Foundation
import AppKit

protocol LayoutPreviewViewDelegate {
    
    func onPreviewSelected(preview: LayoutPreviewView.LayoutPreview, payload: Any?)
    
}

class LayoutPreviewView: NSView {
    
    typealias LayoutPreview = NSRect
    typealias Delegate = LayoutPreviewViewDelegate
    
    private static let filteringOptions = [NSPasteboard.ReadingOptionKey.urlReadingContentsConformToTypes:[NSPasteboard.PasteboardType.windowPid]]
    
    private let projectionBounds = NSRect(x: 0, y: 0, width: 1, height: 1)
    
    private var layoutPreviews: [LayoutPreview] = []
    private var projectedPreviews: [LayoutPreview] = []
    private var highlightedPreivew: LayoutPreview? = nil
    
    var delegate: Delegate? = nil
    
    private var inactiveLayoutPreviewColor: NSColor = .blue
    private var activeLayoutPreviewColor: NSColor = .red
    
    private var roundRadius: CGFloat = 4
    private var paddingBetweenPreviews: CGFloat = 4 {
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
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        let allow = shouldAllowDrag(sender)
        isReceivingDrag = allow
        return allow ? .copy : NSDragOperation()
    }
    
    override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation {
        let mousePosition = sender.draggingLocation
        let pointerPosition = convert(mousePosition, from: nil)
        
        let foundProjection = findHighlightedProjection(position: pointerPosition)
        highlightedPreivew = foundProjection
        
        needsDisplay = true
        return .copy
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
      highlightedPreivew = nil
      isReceivingDrag = false
    }
    
    private func shouldAllowDrag(_ draggingInfo: NSDraggingInfo) -> Bool {
      let pasteBoard = draggingInfo.draggingPasteboard
      if pasteBoard.canReadObject(forClasses: [WindowPidPasteboard.self], options: LayoutPreviewView.filteringOptions) {
        return true
      }
      return false
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        isReceivingDrag = false
        let pasteBoard = sender.draggingPasteboard
        let point = convert(sender.draggingLocation, from: nil)
        let projection = findHighlightedProjection(position: point)
        
        highlightedPreivew = nil
        needsDisplay = true
        
        if let pids = pasteBoard.readObjects(forClasses: [WindowPidPasteboard.self], options: LayoutPreviewView.filteringOptions) as? [WindowPidPasteboard], pids.count > 0, let projection = projection {
            delegate?.onPreviewSelected(preview: layoutPreviews[projectedPreviews.firstIndex(of: projection)!], payload: pids)
          return true
        }
        
        return false
    }
    
    private func findHighlightedProjection(position: NSPoint) -> LayoutPreview? {
        for prjection in projectedPreviews {
            if prjection.contains(position) {
                return prjection
            }
        }
        
        return nil
    }
    
    func addLayoutPreview(layoutPreview: LayoutPreview) {
        layoutPreviews.append(layoutPreview)
        projectedPreviews.append(getLayoutProjection(layoutPreview: layoutPreview, padding: paddingBetweenPreviews))
        setNeedsDisplay(bounds)
    }
    
    private func updateLayoutProjections() {
        projectedPreviews.removeAll()
        
        for preview in projectedPreviews {
            projectedPreviews.append(getLayoutProjection(layoutPreview: preview, padding: paddingBetweenPreviews))
        }
    }
    
    func clear() {
        layoutPreviews.removeAll()
        projectedPreviews.removeAll()
        setNeedsDisplay(bounds)
    }
    
    func setBackgroundColor(backgroundColor: CGColor) {
        wantsLayer = true
        layer?.backgroundColor = backgroundColor
        layer?.masksToBounds = true
        layer?.cornerRadius = roundRadius
    }
    
    override func draw(_ dirtyRect: NSRect) {
        if isReceivingDrag {
            NSColor.selectedControlColor.set()
            
            let path = NSBezierPath(rect:bounds)
            path.lineWidth = 2
            path.stroke()
        }
        
        for projection in projectedPreviews {
            if projection == highlightedPreivew {
                continue
            }
            
            drawScreen(projection: projection, color: inactiveLayoutPreviewColor)
        }
        
        if let highlightedPreivew = highlightedPreivew {
            drawScreen(projection: highlightedPreivew, color: activeLayoutPreviewColor)
        }
    }
    
    private func drawScreen(projection: LayoutPreview, color: NSColor) {
        let path: NSBezierPath = NSBezierPath.init(roundedRect: projection, xRadius: roundRadius, yRadius: roundRadius)
        
        color.setFill()
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
