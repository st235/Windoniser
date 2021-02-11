import Foundation

class PermissionsViewController: NSViewController {
    
    private var accessibilityPermissionsManager: AccessibilityPermissionsManager? = nil
    @IBOutlet weak var grantPermissionButton: NSButton!
    
    override func viewDidLoad() {
        grantPermissionButton.target = self
        grantPermissionButton.sendAction(on: .leftMouseUp)
        grantPermissionButton.action = #selector(onButtonClicked(_:))
    }
    
    @objc private func onButtonClicked(_ sender: Any?) {
        accessibilityPermissionsManager?.requestPermission()
    }
    
    static func create(accessibilityPermissionsManager: AccessibilityPermissionsManager = AppDependenciesResolver.shared.resolve(type: AccessibilityPermissionsManager.self)) -> PermissionsViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("MainFlow"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("PermissionsViewController")
        guard let viewController = storyboard.instantiateController(withIdentifier: identifier) as? PermissionsViewController else {
            fatalError("Check storyboard. Probably, id of view controller does not match with id below")
        }
      
        viewController.accessibilityPermissionsManager = accessibilityPermissionsManager
        
        return viewController
    }
}
