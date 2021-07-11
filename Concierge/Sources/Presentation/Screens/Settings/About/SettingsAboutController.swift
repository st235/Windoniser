import Foundation

class SettingsAboutController: NavigatableViewController {
    
    @IBOutlet weak var iconView: NSImageView!
    @IBOutlet weak var applicationTitle: NSTextField!
    @IBOutlet weak var applicationDescription: NSTextField!
    @IBOutlet weak var aboutItemsListStackView: NSStackView!
    @IBOutlet weak var versionHeader: NSTextField!
    
    private let settingsItems: [SettingsItem] =
        [
            SettingsPrivacyItem(),
            SettingsTermsItem(),
            ContactUsItem(),
        ];
    
    override var navigationTitle: String {
        get {
            return "settings_item_about".localized
        }
    }
    
    override func viewDidLoad() {
        updateStaticViews()
        
        let defaultItemFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 62.0)
        
        for item in settingsItems {
            let view = item.createView(frame: defaultItemFrame)
            view.clickHandler = { [weak self] in
                guard let navigatable = self?.parent as? Navigatable else {
                    return
                }
                item.handleClick(navigatable: navigatable)
            }
            
            aboutItemsListStackView.addArrangedSubview(view)
        }
    }
    
    private func updateStaticViews() {
        let bundle = Bundle.main
        
        updateVersionTitle(bundle: bundle)
        
        iconView.image = bundle.icon
        applicationTitle.stringValue = bundle.name ?? ""
        applicationDescription.stringValue = "settings_about_motto".localized
    }
    
    private func updateVersionTitle(bundle: Bundle) {
        guard let version = bundle.version else {
            versionHeader.stringValue = "settings_about_version_no_version".localized
            return
        }
        
        versionHeader.stringValue = "\("settings_about_version_header".localized) \(version)"
    }
        
}

fileprivate extension Bundle {
    
    var name: String? {
        return infoDictionary?["CFBundleName"] as? String
    }
    
    var version: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var icon: NSImage? {
        if let icon = infoDictionary?["CFBundleIconName"] as? String {
            return NSImage(named: icon)
        }
        return nil
    }
    
}
