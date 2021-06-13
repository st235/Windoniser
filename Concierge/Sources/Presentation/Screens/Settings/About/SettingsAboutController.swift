import Foundation

class SettingsAboutController: NSViewController {
    
    @IBOutlet weak var versionHeader: NSTextField!
    
    override func viewDidLoad() {
        updateVersionTitle()
    }
    
    private func updateVersionTitle() {
        let nsObject: Any? = Bundle.main.infoDictionary?["CFBundleShortVersionString"]
        
        guard let version = nsObject as? String else {
            versionHeader.stringValue = "settings_about_version_no_version".localized
            return
        }
        
        versionHeader.stringValue = "\("settings_about_version_header".localized) \(version)"
    }
    
}
