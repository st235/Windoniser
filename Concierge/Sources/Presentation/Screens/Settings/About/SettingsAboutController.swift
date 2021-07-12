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
            CheckForUpdateItem(),
            ContactUsItem(),
        ];
    
    override var navigationTitle: String {
        get {
            return "settings_item_about".localized
        }
    }
    
    override func viewDidLoad() {
        updateStaticViews()
        
        for item in settingsItems {
            let itemView = item.createView()
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            itemView.clickHandler = { [weak self] in
                guard let navigatable = self?.parent as? Navigatable else {
                    return
                }
                item.handleClick(navigatable: navigatable)
            }
            
            aboutItemsListStackView.addArrangedSubview(itemView)

            itemView.heightAnchor.constraint(equalToConstant: 62.0).isActive = true
            itemView.leadingAnchor.constraint(equalTo: aboutItemsListStackView.leadingAnchor, constant: 0).isActive = true
            itemView.trailingAnchor.constraint(equalTo: aboutItemsListStackView.trailingAnchor, constant: 0).isActive = true
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
