import Foundation

struct LayoutArea {
    
    let titleKey: String
    let activeKey: Key
    let modifiers: NSEvent.ModifierFlags
    let rect: NSRect
    
    init(titleKey: String, activeKey: Key, modifiers: NSEvent.ModifierFlags, rect: NSRect) {
        self.titleKey = titleKey
        self.activeKey = activeKey
        self.modifiers = modifiers
        self.rect = rect
    }
    
}
