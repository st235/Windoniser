import Foundation

class BuyUsACoffeeItem: SettingsItem {
    
    func createView() -> SettingsItemView {
        let item = SettingsItemView()
        
        item.isArrowShown = false
        item.icon = NSImage(systemSymbolName: "app.gift", accessibilityDescription: nil)
        item.text = "settings_item_buy_us_a_coffee".localized
        
        return item
    }
    
    func handleClick(navigatable: Navigatable) {
        guard let url = URL(string: "https://www.buymeacoffee.com/windoniser") else {
            return
        }
        
        NSWorkspace.shared.open(url)
    }
    
}
