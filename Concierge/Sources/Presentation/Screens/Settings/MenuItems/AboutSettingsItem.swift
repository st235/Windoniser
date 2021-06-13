import Foundation

class AboutSettingsItem: SettingsItem {
    
    func createView(frame: CGRect) -> SettingsItemView {
        let item = SettingsItemView(frame: frame)
        
        item.isArrowShown = true
        item.icon = NSImage(systemSymbolName: "info.circle", accessibilityDescription: nil)
        item.text = "settings_item_about".localized
        
        return item
    }
    
    func handleClick(navigatable: Navigatable) {
        navigatable.push(controllerId: .settingsAbout, bundle: nil)
    }
    
}
