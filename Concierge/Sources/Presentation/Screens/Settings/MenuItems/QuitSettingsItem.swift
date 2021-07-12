import Foundation

class QuitSettingsItem: SettingsItem {
    
    func createView() -> SettingsItemView {
        let item = SettingsItemView()
        
        item.isArrowShown = false
        item.icon = nil
        item.text = "settings_item_quit".localized
        
        return item
    }
    
    func handleClick(navigatable: Navigatable) {
        NSApp.terminate(self)
    }
    
}
