import Foundation


class SettingsViewController: NSViewController {
    
    @IBOutlet weak var tableView: NSTableView!
    
    private var layoutShemesInteractor: LayoutSchemesInteractor {
        get {
            return AppDependenciesResolver.shared.resolve(type: LayoutSchemesInteractor.self)
        }
    }
    
    private var tableViewAdapter: SettingsTableAdapter? = nil
    
    override func viewDidLoad() {
        tableView.isEnabled = true
        
        let schemes = layoutShemesInteractor.defaultSchemes()
        tableViewAdapter = SettingsTableAdapter(schemes: schemes)
        
        tableViewAdapter?.handler = { [weak self] scheme in
            self?.layoutShemesInteractor.activeScheme = scheme
        }
        
        tableView.delegate = tableViewAdapter
        tableView.dataSource = tableViewAdapter
    }
    
}
