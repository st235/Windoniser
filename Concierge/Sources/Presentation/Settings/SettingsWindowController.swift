import Foundation

class SettingsWindowController: NSWindowController {
    
    override func windowDidLoad() {
        print("Window did load")
    }
    
    static func create() -> SettingsWindowController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("MainFlow"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("SettingsWindowController")
        guard let windowController = storyboard.instantiateController(withIdentifier: identifier) as? SettingsWindowController else {
            fatalError("Check storyboard. Probably, id of view controller does not match with id below")
        }
        
        return windowController
    }
    
}
