import Foundation

class QuitSettingsItem: SettingsItem {
    
    func createView(frame: CGRect) -> SettingsItemView {
        let item = SettingsItemView(frame: frame)
        
        item.isArrowShown = false
        item.icon = nil
        item.text = "settings_item_quit".localized
        
        return item
    }
    
    func handleClick(navigatable: Navigatable) {
        NSApp.terminate(self)
    }
    
}
