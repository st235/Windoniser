import Foundation

class GeneralSettingsItem: SettingsItem {
    
    func createView() -> SettingsItemView {
        let item = SettingsItemView()
        
        item.isArrowShown = true
        item.icon = NSImage(systemSymbolName: "gearshape", accessibilityDescription: nil)
        item.text = "settings_item_general".localized
        
        return item
    }
    
    func handleClick(navigatable: Navigatable) {
        navigatable.push(controllerId: .settingsGeneral, bundle: nil)
    }
    
}
