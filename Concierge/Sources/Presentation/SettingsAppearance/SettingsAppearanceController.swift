import Foundation

class SettingsAppearanceController: NSViewController {
    
    @IBOutlet weak var systemRadioButton: NSButton!
    @IBOutlet weak var lightRadioButton: NSButton!
    @IBOutlet weak var darkRadioButton: NSButton!
    
    private let settingsManager: SettingsManager = AppDependenciesResolver.shared.resolve(type: SettingsManager.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearanceMode: AppearanceMode = settingsManager.get(type: .appearance)
        
        switch appearanceMode {
        case .followSystem: systemRadioButton.state = NSControl.StateValue.on
        case .forceLight: lightRadioButton.state = NSControl.StateValue.on
        case .forceDark: darkRadioButton.state = NSControl.StateValue.on
        }
        
    }
    
    @IBAction func onRadioClicked(_ sender: NSButton) {
        if systemRadioButton.state == NSControl.StateValue.on {
            settingsManager.set(type: .appearance, value: AppearanceMode.followSystem)
        } else if lightRadioButton.state == NSControl.StateValue.on {
            settingsManager.set(type: .appearance, value: AppearanceMode.forceLight)
        } else {
            settingsManager.set(type: .appearance, value: AppearanceMode.forceDark)
        }
    }
    
    
}
