import Foundation

class AboutSettingsItem: SettingsItem {
    
    func createView(frame: CGRect) -> SettingsItemView {
        let item = SettingsItemView(frame: frame)
        
        item.isArrowShown = true
        item.icon = NSImage(named: "IconInfo")
        item.text = "settings_item_about".localized
        
        return item
    }
    
    func handleClick(navigatable: Navigatable) {
    }
    
}
