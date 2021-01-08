protocol MenuItem {
    
    var nsMenuItem: NSMenuItem { get }
    
}

class SchemeAreaMenuItem: MenuItem {
    
    private let _item: NSMenuItem
    private let area: LayoutArea
    private let windowInteractor: WindowInteractor
    
    var nsMenuItem: NSMenuItem {
        get {
            return _item
        }
    }
    
    init(area: LayoutArea,
         windowInteractor: WindowInteractor) {
        self.area = area
        self.windowInteractor = windowInteractor
        
        self._item = NSMenuItem(title: area.title, action: #selector(onMenuItemClick(_:)), keyEquivalent: area.activeKey.description)
        self._item.keyEquivalentModifierMask = area.modifiers
        
        self._item.target = self
    }
    
    @objc private func onMenuItemClick(_ sender: Any?) {
        windowInteractor.resizeFocusedWindow(intoRect: area.rect)
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
