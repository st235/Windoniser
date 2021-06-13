import Foundation

class AppearanceSettingsItem: SettingsItem {
    
    func createView(frame: CGRect) -> SettingsItemView {
        let item = SettingsItemView(frame: frame)
        
        item.isArrowShown = true
        item.icon = NSImage(systemSymbolName: "paintbrush", accessibilityDescription: nil)
        item.text = "settings_item_appearance".localized
        
        return item
    }
    
    func handleClick(navigatable: Navigatable) {
        navigatable.push(controllerId: .settingsAppearance, bundle: nil)
    }
    
}
