import Foundation

protocol SettingsItem {
    
    func createView(frame: CGRect) -> SettingsItemView
    
    func handleClick(navigatable: Navigatable)
    
}
