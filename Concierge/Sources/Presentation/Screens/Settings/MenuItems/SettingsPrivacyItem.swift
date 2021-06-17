import Foundation

class SettingsPrivacyItem: SettingsItem {
    
    func createView(frame: CGRect) -> SettingsItemView {
        let item = SettingsItemView(frame: frame)
        
        item.isArrowShown = true
        item.icon = NSImage(systemSymbolName: "doc.text", accessibilityDescription: nil)
        item.text = "settings_item_privacy".localized
        
        return item
    }
    
    func handleClick(navigatable: Navigatable) {
        let url = Bundle.main.url(forResource: "privacy", withExtension: "html")!
        navigatable.push(controllerId: .settingsLicenses, bundle: SettingsLicensesController.Data(title: "settings_item_privacy".localized, url: url))
    }
    
}
