import Foundation

class RightSideMenuDelegate: NSObject, SideBarMenuDelegate, NSMenuDelegate, LayoutSchemesInteractor.Delegate {
    
    private let statusBarMenuItem: NSStatusItem
    private let menu: NSMenu
    private let rightSideMenuItemsFactory: RightSideMenuItemsFactory
    private let layoutSchemesInteractor: LayoutSchemesInteractor
    
    private var menuItems: [MenuItem] = []
    
    init(statusBarMenuItem: NSStatusItem,
         rightSideMenuItemsFactory: RightSideMenuItemsFactory = AppDependenciesResolver.shared.resolve(type: RightSideMenuItemsFactory.self),
         layoutSchemesInteractor: LayoutSchemesInteractor = AppDependenciesResolver.shared.resolve(type: LayoutSchemesInteractor.self)) {
        self.statusBarMenuItem = statusBarMenuItem
        self.menu = NSMenu()
        self.rightSideMenuItemsFactory = rightSideMenuItemsFactory
        self.layoutSchemesInteractor = layoutSchemesInteractor
        
        super.init()
        
        self.menu.delegate = self
        layoutSchemesInteractor.addDelegate(weak: self)
        
        menuItems = rightSideMenuItemsFactory.create()
        for item in menuItems {
            self.menu.addItem(item.nsMenuItem)
        }
    }
    
    func onActiveSchemeChanged(schemes: LayoutScheme) {
        menuItems.removeAll()
        
        self.menu.removeAllItems()
        
        menuItems = rightSideMenuItemsFactory.create()
        for item in menuItems {
            self.menu.addItem(item.nsMenuItem)
        }
    }
    
    func canHandle(sideBarEvent: SideBarEvent) -> Bool {
        if case let SideBarEvent.mouse(event) = sideBarEvent {
            return event == .rightMouseUp
        }
        
        return false
    }
    
    func attach() {
        self.statusBarMenuItem.menu = menu
        self.statusBarMenuItem.button?.performClick(nil)
    }
    
    func menuDidClose(_ menu: NSMenu) {
        self.statusBarMenuItem.menu = nil
    }

}
