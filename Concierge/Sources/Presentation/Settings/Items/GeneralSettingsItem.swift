import Foundation

class GeneralSettingsItem: SettingsItem {
    
    func createView(frame: CGRect) -> SettingsItemView {
        let item = SettingsItemView(frame: frame)
        
        item.isArrowShown = true
        item.icon = NSImage(named: "IconSettings")
        item.text = "settings_item_general".localized
        
        return item
    }
    
    func handleClick(navigatable: Navigatable) {
        
    }
    
}
