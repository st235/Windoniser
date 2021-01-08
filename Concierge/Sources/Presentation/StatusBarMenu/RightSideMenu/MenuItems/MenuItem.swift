protocol MenuItem {
    
    var nsMenuItem: NSMenuItem { get }
    
}

class SchemeAreaMenuItem: MenuItem {
    
    private let _item: NSMenuItem
    private let area: LayoutArea
    private let windowRepository: WindowRepository
    private let screenController: ScreensController
    
    var nsMenuItem: NSMenuItem {
        get {
            return _item
        }
    }
    
    init(area: LayoutArea,
         windowRepository: WindowRepository,
         screenController: ScreensController) {
        self.area = area
        self.windowRepository = windowRepository
        self.screenController = screenController
        
        self._item = NSMenuItem(title: area.title, action: #selector(onMenuItemClick(_:)), keyEquivalent: area.activeKey.description)
        self._item.keyEquivalentModifierMask = area.modifiers
        
        self._item.target = self
    }
    
    @objc private func onMenuItemClick(_ sender: Any?) {
        let reverse = NSRect(x: area.rect.minX, y: 1.0 - area.rect.height - area.rect.minY, width: area.rect.width, height: area.rect.height)
        if let activeWindow = windowRepository.focusedWindow() {
            screenController.resize(window: activeWindow, projection: reverse)
        }
    }
    
}

class Separator: MenuItem {
    
    var nsMenuItem: NSMenuItem {
        get {
            return NSMenuItem.separator()
        }
    }
    
}

class QuitMenuItem: MenuItem {
    
    var nsMenuItem: NSMenuItem {
        get {
            return NSMenuItem(title: "menu_actions_quit".localized, action: #selector(NSApp.terminate(_:)), keyEquivalent: "q")
        }
    }
    
}
