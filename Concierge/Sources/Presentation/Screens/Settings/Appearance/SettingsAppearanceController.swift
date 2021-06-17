import Foundation

class SettingsAppearanceController: NavigatableViewController {
    
    @IBOutlet weak var appearanceHeader: NSTextField!
    @IBOutlet weak var appearanceContent: NSSegmentedControl!
    
    @IBOutlet weak var desktopLayoutHeader: NSTextField!
    @IBOutlet weak var desktopLayoutView: DesktopLayoutView!
    
    @IBOutlet weak var gridThemeHader: NSTextField!
    @IBOutlet weak var gridThemeContent: NSSegmentedControl!
    
    private let appearanceInteractor: AppearanceInteractor = AppDependenciesResolver.shared.resolve(type: AppearanceInteractor.self)
    private let windowInteractor: WindowInteractor = AppDependenciesResolver.shared.resolve(type: WindowInteractor.self)
    private let layoutSchemesInteractor: LayoutSchemesInteractor = AppDependenciesResolver.shared.resolve(type: LayoutSchemesInteractor.self)
    private let gridLayoutInteractor: GridLayoutInteractor = AppDependenciesResolver.shared.resolve(type: GridLayoutInteractor.self)
    
    private lazy var uiDelegates: [UiDelegate]  = {
        [
            DesktopViewUiDelegate(header: desktopLayoutHeader, content: desktopLayoutView, windowInteractor: windowInteractor, layoutSchemesInteractor: layoutSchemesInteractor, gridLayoutInteractor: gridLayoutInteractor),
            SettingsAppearanceDelegate(header: appearanceHeader, content: appearanceContent, appearanceInteractor: appearanceInteractor),
            SettingsGridLayoutDelegate(header: gridThemeHader, content: gridThemeContent, gridLayoutInteractor: gridLayoutInteractor),
        ]
    }()
    
    override var navigationTitle: String {
        get {
            return "settings_item_appearance".localized
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        for uiDelegate in uiDelegates {
            uiDelegate.update()
        }
    }

}
