import Foundation

class SettingsGeneralController: NSViewController {
    
    @IBOutlet weak var autoLoginCheckBox: NSButton!
    
    private let settingsManager: SettingsRepository = AppDependenciesResolver.shared.resolve(type: SettingsRepository.self)
    
    override func viewDidLoad() {
        let autologinEnabled: Bool = settingsManager.get(type: .autoLogin)
        
        if autologinEnabled {
            autoLoginCheckBox.state = NSControl.StateValue.on
        } else {
            autoLoginCheckBox.state = NSControl.StateValue.off
        }
    }
    
    @IBAction func onAutoLoginCicked(_ sender: NSButton) {
        if autoLoginCheckBox.state == .on {
            settingsManager.set(type: .autoLogin, value: true)
        } else {
            settingsManager.set(type: .autoLogin, value: false)
        }
    }
}
