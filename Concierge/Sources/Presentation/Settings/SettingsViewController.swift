import Foundation


class SettingsViewController: NSViewController {
    
    @IBOutlet weak var autoLoginCheckBox: NSButton!
    
    private var settingsManager: SettingsManager {
        get {
            return AppDependenciesResolver.shared.resolve(type: SettingsManager.self)
        }
    }
    
    override func viewDidLoad() {
        let autoLoginEnabled: Bool = settingsManager.get(type: .autoLogin)
        autoLoginCheckBox.state = autoLoginEnabled ? .on : .off
    }
    
    @IBAction func onToggleClicked(_ sender: Any) {
        switch autoLoginCheckBox.state {
        case .on:
            settingsManager.set(type: .autoLogin, value: true)
        case .off:
            settingsManager.set(type: .autoLogin, value: false)
        default:
            fatalError()
        }
    }
}
