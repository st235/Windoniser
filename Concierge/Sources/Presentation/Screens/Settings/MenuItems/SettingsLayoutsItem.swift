import Foundation

class SettingsLayoutsItem: SettingsItem {
    
    func createView(frame: CGRect) -> SettingsItemView {
        let item = SettingsItemView(frame: frame)
        
        item.isArrowShown = true
        item.icon = NSImage(systemSymbolName: "rectangle.3.offgrid", accessibilityDescription: nil)
        item.text = "settings_item_layouts".localized
        
        return item
    }
    
    func handleClick(navigatable: Navigatable) {
        navigatable.push(controllerId: .settingsLayouts, bundle: nil)
    }
    
}
