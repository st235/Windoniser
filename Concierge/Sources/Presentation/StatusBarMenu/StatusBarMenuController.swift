import Foundation

class StatusBarMenuController: LayoutSchemesInteractor.Delegate {
    
    private let statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    private let delegates: [SideBarMenuDelegate]
    private let layoutSchemesInteractor: LayoutSchemesInteractor
    
    private let accessibilityPermissionsManager: AccessibilityPermissionsManager
    private let layoutSchemeIconsFactory = LayoutSchemeIconsFactory()
    
    init(layoutSchemesInteractor: LayoutSchemesInteractor,
         accessibilityPermissionsManager: AccessibilityPermissionsManager) {
        self.delegates = [
            LeftSideMenuDelegate(statusBarMenuItem: self.statusBarItem),
            RightSideMenuDelegate(statusBarMenuItem: self.statusBarItem),
            PermissionsSideMenuDelegate(statusBarMenuItem: self.statusBarItem)
        ]
        self.layoutSchemesInteractor = layoutSchemesInteractor
        self.accessibilityPermissionsManager = accessibilityPermissionsManager
        
        self.layoutSchemesInteractor.addDelegate(weak: self)
    }
    
    func onActiveSchemeChanged(schemes: LayoutScheme) {
        if let button = statusBarItem.button {
            button.image = layoutSchemeIconsFactory.findIconForScheme(scheme: layoutSchemesInteractor.activeScheme)
        }
    }
    
    func attach() {        
        if let button = statusBarItem.button {
            button.image = layoutSchemeIconsFactory.findIconForScheme(scheme: layoutSchemesInteractor.activeScheme)
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
            button.target = self
            button.action = #selector(onStatusBarItemClick(_:))
        }
    }
    
    @objc private func onStatusBarItemClick(_ sender: Any?) {
        let event = NSApp.currentEvent!
        
        if (!accessibilityPermissionsManager.isPermissionGranted()) {
            attachActiveDelegates(sideBarEvent: .permissionError)
        } else {
            attachActiveDelegates(sideBarEvent: .mouse(event: event.type))
        }
    }
    
    private func attachActiveDelegates(sideBarEvent: SideBarEvent) {
        for delegate in delegates {
            if delegate.canHandle(sideBarEvent: sideBarEvent) {
                delegate.attach()
            }
        }
    }
    
}
