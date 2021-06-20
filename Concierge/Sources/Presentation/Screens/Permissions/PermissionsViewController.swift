import Foundation

class PermissionsViewController: NSViewController {
    
    private var accessibilityPermissionsManager: AccessibilityPermissionsManager = AppDependenciesResolver.shared.resolve(type: AccessibilityPermissionsManager.self)
    
    @IBOutlet weak var grantPermissionButton: NSButton!
    @IBOutlet weak var contentDescriptionLabel: NSTextField!
    @IBOutlet weak var closeApplicationButton: NSButton!
    
    override func viewDidLoad() {
        contentDescriptionLabel.stringValue = "permissions_screen_description".localized
        grantPermissionButton.title = "permissions_grant_button_text".localized
        closeApplicationButton.title = "permissions_close_app_button_text".localized
        
        grantPermissionButton.target = self
        grantPermissionButton.sendAction(on: .leftMouseUp)
        grantPermissionButton.action = #selector(onButtonClicked(_:))
        
        closeApplicationButton.target = self
        closeApplicationButton.sendAction(on: .leftMouseUp)
        closeApplicationButton.action = #selector(onQuitApplicationClicked(_:))
    }
    
    @objc private func onButtonClicked(_ sender: Any?) {
        accessibilityPermissionsManager.requestPermission()
    }
    
    @objc private func onQuitApplicationClicked(_ sender: Any?) {
        NSApp.terminate(nil)
    }
    
}
