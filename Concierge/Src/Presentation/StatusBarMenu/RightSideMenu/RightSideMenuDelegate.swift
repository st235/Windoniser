import Foundation

class RightSideMenuDelegate: NSObject, SideBarMenuDelegate, NSMenuDelegate {
    
    private let statusBarMenuItem: NSStatusItem
    private let menu: NSMenu
    
    init(statusBarMenuItem: NSStatusItem) {
        self.statusBarMenuItem = statusBarMenuItem
        self.menu = NSMenu()
        
        super.init()
        
        self.menu.delegate = self
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApp.terminate(_:)), keyEquivalent: "q"))
    }
    
    func canHandle(event: NSEvent.EventType) -> Bool {
        return event == .rightMouseUp
    }
    
    func attach() {
        self.statusBarMenuItem.menu = menu
        self.statusBarMenuItem.button?.performClick(nil)
    }
    
    func menuDidClose(_ menu: NSMenu) {
        self.statusBarMenuItem.menu = nil
    }

}
