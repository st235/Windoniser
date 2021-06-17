import Foundation

class SettingsListViewController: NavigatableViewController {
    
    @IBOutlet weak var menuStackView: NSStackView!
    
    private let settingsItems: [SettingsItem] =
        [
            GeneralSettingsItem(),
            SettingsLayoutsItem(),
            AppearanceSettingsItem(),
            AboutSettingsItem(),
            SettingsPrivacyItem(),
            SettingsTermsItem(),
            QuitSettingsItem()
        ];
    
    override var navigationTitle: String {
        get {
            return "settings_list_view_header".localized
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaultItemFrame = CGRect(x: 0, y: 0, width: self.menuStackView.frame.width, height: 62.0)
        
        for item in settingsItems {
            let view = item.createView(frame: defaultItemFrame)
            view.clickHandler = { [weak self] in
                guard let navigatable = self?.parent as? Navigatable else {
                    return
                }
                item.handleClick(navigatable: navigatable)
            }
            menuStackView.addArrangedSubview(view)
        }
    }
    
}
