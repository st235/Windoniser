import Foundation

protocol SettingsItem {
    
    func createView() -> SettingsItemView
    
    func handleClick(navigatable: Navigatable)
    
}
