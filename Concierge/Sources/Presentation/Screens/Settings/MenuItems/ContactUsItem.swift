import Foundation

class ContactUsItem: SettingsItem {
    
    func createView() -> SettingsItemView {
        let item = SettingsItemView()
        
        item.isArrowShown = false
        item.icon = NSImage(systemSymbolName: "envelope", accessibilityDescription: nil)
        item.text = "settings_item_drop_us_a_line".localized
        
        return item
    }
    
    func handleClick(navigatable: Navigatable) {
        guard let url = URL(string: "mailto:windoniser@wonderlab.tech") else {
            return
        }
        
        NSWorkspace.shared.open(url)
    }
    
}
