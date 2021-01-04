import Foundation

class RightSideMenuItemsFactory {
    
    func create() -> [NSMenuItem] {
        var items: [NSMenuItem] = []
        
        items.append(createQuitItem())
        
        return items
    }
    
    private func createQuitItem() -> NSMenuItem {
        return NSMenuItem(title: NSLocalizedString("menu_actions_quit", comment: "Quit menu item"), action: #selector(NSApp.terminate(_:)), keyEquivalent: "q")
    }
    
}
