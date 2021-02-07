import Foundation

class WindowTableRow: NSTableRowView {
    
    private let activeColor: NSColor = NSColor.from(name: .backgroundPrimary)
    
    private let roundRadius: CGFloat = 8
    
    override func drawBackground(in dirtyRect: NSRect) {
        activeColor.setFill()
        let path = NSBezierPath.init(roundedRect: dirtyRect.insetBy(dx: 0, dy: 2), xRadius: roundRadius, yRadius: roundRadius)
        path.fill()
    }
    
}
