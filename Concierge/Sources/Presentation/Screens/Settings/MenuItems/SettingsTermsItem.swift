import Foundation

class SettingsTermsItem: SettingsItem {
    
    func createView() -> SettingsItemView {
        let item = SettingsItemView()
        
        item.isArrowShown = true
        item.icon = NSImage(systemSymbolName: "doc.text", accessibilityDescription: nil)
        item.text = "settings_item_terms_and_conditions".localized
        
        return item
    }
    
    func handleClick(navigatable: Navigatable) {
        let url = Bundle.main.url(forResource: "terms", withExtension: "html")!
        navigatable.push(controllerId: .settingsLicenses, bundle: SettingsLicensesController.Data(title: "settings_item_terms_and_conditions".localized, url: url))
    }
    
}
