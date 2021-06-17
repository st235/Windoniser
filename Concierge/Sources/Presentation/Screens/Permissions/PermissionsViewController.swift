import Foundation

class PermissionsViewController: NSViewController {
    
    private var accessibilityPermissionsManager: AccessibilityPermissionsManager = AppDependenciesResolver.shared.resolve(type: AccessibilityPermissionsManager.self)
    @IBOutlet weak var grantPermissionButton: NSButton!
    
    override func viewDidLoad() {
        grantPermissionButton.target = self
        grantPermissionButton.sendAction(on: .leftMouseUp)
        grantPermissionButton.action = #selector(onButtonClicked(_:))
    }
    
    @objc private func onButtonClicked(_ sender: Any?) {
        accessibilityPermissionsManager.requestPermission()
    }
    
}
