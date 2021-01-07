import Foundation

class RightSideMenuDelegate: NSObject, SideBarMenuDelegate, NSMenuDelegate {
    
    private let statusBarMenuItem: NSStatusItem
    private let menu: NSMenu
    private let rightSideMenuItemsFactory: RightSideMenuItemsFactory
    
    private var menuItems: [MenuItem] = []
    
    init(statusBarMenuItem: NSStatusItem) {
        self.statusBarMenuItem = statusBarMenuItem
        self.menu = NSMenu()
        self.rightSideMenuItemsFactory = RightSideMenuItemsFactory()
        
        super.init()
        
        self.menu.delegate = self
        
        menuItems = rightSideMenuItemsFactory.create()
        for item in menuItems {
            self.menu.addItem(item.nsMenuItem)
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
