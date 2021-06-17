import Foundation

struct LayoutArea {
    
    let titleKey: String
    let activeKey: Key
    let rect: NSRect
    
    init(titleKey: String, activeKey: Key, rect: NSRect) {
        self.titleKey = titleKey
        self.activeKey = activeKey
        self.rect = rect
    }
    
}
