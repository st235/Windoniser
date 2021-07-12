import Foundation

class SettingsListViewController: NavigatableViewController {
    
    @IBOutlet weak var menuStackView: NSStackView!
    
    private let settingsItems: [SettingsItem] =
        [
            GeneralSettingsItem(),
            SettingsLayoutsItem(),
            AppearanceSettingsItem(),
            AboutSettingsItem(),
            BuyUsACoffeeItem(),
            QuitSettingsItem()
        ];
    
    override var navigationTitle: String {
        get {
            return "settings_list_view_header".localized
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for item in settingsItems {
            let itemView = item.createView()
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            itemView.clickHandler = { [weak self] in
                guard let navigatable = self?.parent as? Navigatable else {
                    return
                }
                item.handleClick(navigatable: navigatable)
            }
            
            menuStackView.addArrangedSubview(itemView)

            itemView.heightAnchor.constraint(equalToConstant: 62.0).isActive = true
            itemView.leadingAnchor.constraint(equalTo: menuStackView.leadingAnchor, constant: 0).isActive = true
            itemView.trailingAnchor.constraint(equalTo: menuStackView.trailingAnchor, constant: 0).isActive = true
        }
    }
    
}
