import Foundation

class WindowTableRow: NSTableRowView {
    
    private let activeColor: NSColor = NSColor.from(hex: "#74748088")
    private let inActiveColor: NSColor = NSColor.from(hex: "#74748022")
    
    private let roundRadius: CGFloat = 8
    
    override func drawSelection(in dirtyRect: NSRect) {
        activeColor.setFill()
        let path = NSBezierPath.init(roundedRect: dirtyRect.insetBy(dx: 0, dy: 2), xRadius: roundRadius, yRadius: roundRadius)
        path.fill()
    }
    
    override func drawBackground(in dirtyRect: NSRect) {
        inActiveColor.setFill()
        let path = NSBezierPath.init(roundedRect: dirtyRect.insetBy(dx: 0, dy: 2), xRadius: roundRadius, yRadius: roundRadius)
        path.fill()
    }
    
}
