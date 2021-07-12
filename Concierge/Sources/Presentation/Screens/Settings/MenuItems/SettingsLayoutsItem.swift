import Foundation

class SettingsLayoutsItem: SettingsItem {
    
    func createView() -> SettingsItemView {
        let item = SettingsItemView()
        
        item.isArrowShown = true
        item.icon = NSImage(systemSymbolName: "rectangle.3.offgrid", accessibilityDescription: nil)
        item.text = "settings_item_layouts".localized
        
        return item
    }
    
    func handleClick(navigatable: Navigatable) {
        navigatable.push(controllerId: .settingsLayouts, bundle: nil)
    }
    
}
