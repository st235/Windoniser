import Foundation

public class ViewControllerFactory {
    
    private static let MAIN_STORYBOARD_ID = "MainFlow"
    
    public enum ID: String {
        case main = "MainViewController"
        
        case content = "LeftSideMenuViewController"
        case permissions = "PermissionsViewController"
        case settings = "SettingsViewController"
        case settingsList = "SettingsListViewController"
        case appearance = "AppearanceController"
    }
    
    public func create<T: NSViewController>(id: ID) -> T {
        let storyboard = NSStoryboard(name: NSStoryboard.Name(ViewControllerFactory.MAIN_STORYBOARD_ID), bundle: nil)
        
        let identifier = NSStoryboard.SceneIdentifier(id.rawValue)
        guard let controller = storyboard.instantiateController(withIdentifier: identifier) as? T else {
            fatalError("Check storyboard. Probably, id of view controller does not match with id below")
        }
        
        return controller
    }
    
}
