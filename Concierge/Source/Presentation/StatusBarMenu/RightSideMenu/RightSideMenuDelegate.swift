import Foundation

class RightSideMenuDelegate: NSObject, SideBarMenuDelegate, NSMenuDelegate {
    
    private let statusBarMenuItem: NSStatusItem
    private let menu: NSMenu
    private let rightSideMenuItemsFactory: RightSideMenuItemsFactory
    
    init(statusBarMenuItem: NSStatusItem) {
        self.statusBarMenuItem = statusBarMenuItem
        self.menu = NSMenu()
        self.rightSideMenuItemsFactory = RightSideMenuItemsFactory()
        
        super.init()
        
        self.menu.delegate = self

        let items = rightSideMenuItemsFactory.create()
        for item in items {
            self.menu.addItem(item)
        }
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
