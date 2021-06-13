import Foundation
import AppKit

protocol _LayoutPreviewViewDelegate: AnyObject {
    
    func onPreviewSelected(preview: LayoutPreviewView.LayoutPreview, payload: Any?)
    
}

class LayoutPreviewView: NSView {

    struct LayoutPreview: Equatable {
        var id: String
        var origin: NSRect
        
        static func ==(lhs: LayoutPreview, rhs: LayoutPreview) -> Bool {
            return lhs.id == rhs.id && lhs.origin == rhs.origin
        }
    }
    
    typealias LayoutSeparator = Vector2
    typealias Delegate = _LayoutPreviewViewDelegate
    
    private static let filteringOptions = [NSPasteboard.ReadingOptionKey.urlReadingContentsConformToTypes:[NSPasteboard.PasteboardType.windowPid]]

    private let projectionBounds = NSRect(x: 0, y: 0, width: 1, height: 1)
    
    private var layoutPreviews: [LayoutPreview] = []
    private var separators: [LayoutSeparator] = []
    
    private var projectedPreviews: [LayoutPreview] = []
    private var projectedSeparators: [LayoutSeparator] = []
    private var highlightedPreivew: LayoutPreview? = nil
    
    private var roundRadius = CGFloat(12)
    
    weak var delegate: Delegate? = nil
    
    var highlightColor: NSColor = NSColor.white.withAlphaComponent(0.6) {
        didSet {
            needsDisplay = true
        }
    }
    
    var backgroundColor: NSColor = NSColor.white.withAlphaComponent(0.3) {
        didSet {
            needsDisplay = true
        }
    }
    
    var borderColor: NSColor = .white {
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
        projectedPreviews.removeAll()
        
        for preview in layoutPreviews {
            projectedPreviews.append(getLayoutProjection(layoutPreview: preview, padding: 0))
        }
        
        projectedSeparators.removeAll()
        
        for separator in separators {
            projectedSeparators.append(getSeparatorProjection(separator: separator))
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
    
    func addLayoutPreviews(layoutPreviews: [LayoutPreview], layoutSeparators: [LayoutSeparator]) {
        self.layoutPreviews = layoutPreviews
        self.separators = layoutSeparators
        
        updateLayoutProjections()
        
        needsDisplay = true
    }
    
    func clear() {
        layoutPreviews.removeAll()
        projectedPreviews.removeAll()
        separators.removeAll()
        projectedSeparators.removeAll()
        highlightedPreivew = nil
        needsDisplay = true
    }
    
    override func draw(_ dirtyRect: NSRect) {
        updateLayoutProjections()
        
        let path = NSBezierPath.init(roundedRect: bounds, xRadius: roundRadius, yRadius: roundRadius)
        
        backgroundColor.setFill()
        path.fill()
        
        if let highlightedPreivew = highlightedPreivew {
            drawActiveScreen(projection: highlightedPreivew)
        }
        
        borderColor.setStroke()
        path.lineWidth = 4.0
        let dashes: [CGFloat] = [10.0, 6.0]
        path.setLineDash(dashes, count: dashes.count, phase: 0.0)
        path.stroke()
        
        for separator in projectedSeparators {
            drawSeparator(separator: separator)
        }
        
        for preview in projectedPreviews {
            drawTextCentered(text: preview.id, frame: preview.origin)
        }
        
    }
    
    private func drawSeparator(separator: Vector2) {
        let path = NSBezierPath.init()
        path.move(to: separator.x)
        path.line(to: separator.y)
        path.lineWidth = 2.0
        let dashes: [CGFloat] = [10.0, 6.0]
        path.setLineDash(dashes, count: dashes.count, phase: 0.0)
        
        borderColor.setStroke()
        path.stroke()
    }
    
    private func drawActiveScreen(projection: LayoutPreview) {
        highlightColor.set()
        let path = NSBezierPath.init(rect: projection.origin)
        path.fill()
    }
    
    private func findHighlightedProjection(position: NSPoint) -> LayoutPreview? {
        for prjection in projectedPreviews {
            if prjection.origin.contains(position) {
                return prjection
            }
        }
        
        return nil
    }
    
    private func drawTextCentered(text: String, frame: NSRect) {
        let string: NSString = text as NSString
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        let dict = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.foregroundColor: borderColor,
            NSAttributedString.Key.font: NSFont.boldSystemFont(ofSize: 32)
        ]
        let size = string.size(withAttributes: dict)
        let r = CGRect(x: frame.origin.x, y: frame.origin.y + (frame.size.height - size.height)/2.0, width: frame.size.width, height: size.height)
        string.draw(in: r, withAttributes: dict)
    }
    
    private func getSeparatorProjection(separator: LayoutSeparator) -> LayoutSeparator {
        return LayoutSeparator(x: NSPoint(x: separator.x.x * bounds.width, y: separator.x.y * bounds.height), y: NSPoint(x: separator.y.x * bounds.width, y: separator.y.y * bounds.height))
    }
    
    private func getLayoutProjection(layoutPreview: LayoutPreview, padding: CGFloat) -> LayoutPreview {
        let origin = layoutPreview.origin
        
        let projectedXScale = origin.width / projectionBounds.width
        let projectedYScale = origin.height / projectionBounds.height
        
        let projectedWidth = projectedXScale * bounds.width - 2 * padding
        let projectedHeight = projectedYScale * bounds.height - 2 * padding
        
        let projectedX = origin.minX * (bounds.width / projectionBounds.width) + padding
        let projectedY = origin.minY * (bounds.height / projectionBounds.height) + padding
        
        return LayoutPreview(id: layoutPreview.id, origin: NSRect(x: projectedX, y: projectedY, width: projectedWidth, height: projectedHeight))
    }
}
