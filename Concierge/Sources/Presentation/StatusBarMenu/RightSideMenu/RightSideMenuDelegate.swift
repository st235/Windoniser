import Foundation

class RightSideMenuDelegate: NSObject, SideBarMenuDelegate, NSMenuDelegate {
    
    private let statusBarMenuItem: NSStatusItem
    private let menu: NSMenu
    private let rightSideMenuItemsFactory: RightSideMenuItemsFactory
    
    private var menuItems: [MenuItem] = []
    
    init(statusBarMenuItem: NSStatusItem,
         rightSideMenuItemsFactory: RightSideMenuItemsFactory = AppDependenciesResolver.shared.resolve(type: RightSideMenuItemsFactory.self)) {
        self.statusBarMenuItem = statusBarMenuItem
        self.menu = NSMenu()
        self.rightSideMenuItemsFactory = rightSideMenuItemsFactory
        
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
