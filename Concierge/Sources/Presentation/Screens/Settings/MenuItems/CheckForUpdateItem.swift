import Foundation

class CheckForUpdateItem: SettingsItem {
    
    func createView() -> SettingsItemView {
        let item = SettingsItemView()
        
        item.isArrowShown = false
        item.icon = NSImage(systemSymbolName: "arrow.triangle.2.circlepath.circle", accessibilityDescription: nil)
        item.text = "settings_item_check_for_updates".localized
        
        return item
    }
    
    func handleClick(navigatable: Navigatable) {
        guard let url = URL(string: "https://www.buymeacoffee.com/windoniser") else {
            return
        }
        
        NSWorkspace.shared.open(url)
    }
    
}
