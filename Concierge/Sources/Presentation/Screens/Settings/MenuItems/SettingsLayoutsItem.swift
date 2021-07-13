import Foundation

class SettingsLayoutsItem: SettingsItem {
    
    func createView() -> SettingsItemView {
        let item = SettingsItemView()
        
        item.isArrowShown = true
        item.icon = NSImage(systemSymbolName: "rectangle.split.3x3", accessibilityDescription: nil)
        item.text = "settings_item_layouts".localized
        
        return item
    }
    
    func handleClick(navigatable: Navigatable) {
        navigatable.push(controllerId: .settingsLayouts, bundle: nil)
    }
    
}
