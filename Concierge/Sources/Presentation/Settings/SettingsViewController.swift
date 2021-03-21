import Foundation


class SettingsViewController: NSViewController {
    
    @IBOutlet weak var autoLoginCheckBox: NSButton!
    @IBOutlet weak var navigationContainer: NSStackView!
    @IBOutlet weak var backButton: NSButton!
    
    private var settingsManager: SettingsManager {
        get {
            return AppDependenciesResolver.shared.resolve(type: SettingsManager.self)
        }
    }
    
    override func viewDidLoad() {
        let autoLoginEnabled: Bool = settingsManager.get(type: .autoLogin)
        autoLoginCheckBox.state = autoLoginEnabled ? .on : .off
        
        backButton.target = self
        backButton.action = #selector(onBackClicked(_:))
        
        navigationContainer?.wantsLayer = true
        navigationContainer?.layer?.backgroundColor = .white
    }
    
    @objc private func onBackClicked(_ sender: Any?) {
        (parent as? NavigationController)?.pop()
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
