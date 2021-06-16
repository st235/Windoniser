import Foundation

class SettingsGeneralController: NSViewController {
    
    @IBOutlet weak var autoLoginCheckBox: NSButton!
    
    @IBOutlet weak var keySchemeLabel: NSTextField!
    @IBOutlet weak var keySchemeView: KeySchemeView!
    
    private let settingsManager: SettingsRepository = AppDependenciesResolver.shared.resolve(type: SettingsRepository.self)
    private let hotKeysInteractor: HotKeysInteractor = AppDependenciesResolver.shared.resolve(type: HotKeysInteractor.self)
    
    private lazy var uiDelegates: [UiDelegate] = {
       [
        SettingsKeySchemeUiDelegate(header: self.keySchemeLabel, content: self.keySchemeView, hotKeysInteractor: self.hotKeysInteractor)
       ]
    }()
    
    override func viewDidLoad() {
        for uiDelegate in uiDelegates {
            uiDelegate.update()
        }
        
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
