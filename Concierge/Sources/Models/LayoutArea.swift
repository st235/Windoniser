import Foundation

struct LayoutArea {
    
    let title: String
    let activeKey: Key
    let modifiers: NSEvent.ModifierFlags
    let rect: NSRect
    
    init(title: String, activeKey: Key, modifiers: NSEvent.ModifierFlags, rect: NSRect) {
        self.title = title
        self.activeKey = activeKey
        self.modifiers = modifiers
        self.rect = rect
    }
    
}
