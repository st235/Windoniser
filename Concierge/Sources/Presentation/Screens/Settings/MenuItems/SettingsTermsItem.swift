import Foundation

class SettingsTermsItem: SettingsItem {
    
    func createView(frame: CGRect) -> SettingsItemView {
        let item = SettingsItemView(frame: frame)
        
        item.isArrowShown = true
        item.icon = NSImage(systemSymbolName: "doc.text", accessibilityDescription: nil)
        item.text = "settings_item_terms_and_conditions".localized
        
        return item
    }
    
    func handleClick(navigatable: Navigatable) {
        let url = Bundle.main.url(forResource: "terms", withExtension: "html")!
        navigatable.push(controllerId: .settingsLicenses, bundle: url)
    }
    
}
