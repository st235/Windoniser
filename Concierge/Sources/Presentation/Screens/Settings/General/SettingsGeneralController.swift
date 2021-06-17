import Foundation

class SettingsGeneralController: NavigatableViewController {
    
    @IBOutlet weak var keySchemeLabel: NSTextField!
    @IBOutlet weak var keySchemeView: KeySchemeView!
    
    @IBOutlet weak var autologinHeader: NSTextField!
    @IBOutlet weak var autologinContent: SwitcherItemView!
    
    private let settingsManager: SettingsRepository = AppDependenciesResolver.shared.resolve(type: SettingsRepository.self)
    private let hotKeysInteractor: HotKeysInteractor = AppDependenciesResolver.shared.resolve(type: HotKeysInteractor.self)
    private let autoLoginInteractor: AutoLoginInteractor = AppDependenciesResolver.shared.resolve(type: AutoLoginInteractor.self)
    
    private lazy var uiDelegates: [UiDelegate] = {
       [
        SettingsKeySchemeUiDelegate(header: self.keySchemeLabel, content: self.keySchemeView, hotKeysInteractor: self.hotKeysInteractor),
        SettingsAutoLoginDelegate(header: self.autologinHeader, content: self.autologinContent, autoLoginInteractor: self.autoLoginInteractor)
       ]
    }()
    
    override var navigationTitle: String {
        get {
            return "settings_item_general".localized
        }
    }
    
    override func viewDidLoad() {
        for uiDelegate in uiDelegates {
            uiDelegate.update()
        }
    }
}
