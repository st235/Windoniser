import Foundation

class SettingsAppearanceController: NSViewController {
    
    @IBOutlet weak var appearanceHeader: NSTextField!
    @IBOutlet weak var appearanceContent: NSSegmentedControl!
    
    @IBOutlet weak var desktopLayoutHeader: NSTextField!
    @IBOutlet weak var desktopLayoutView: DesktopLayoutView!
    
    @IBOutlet weak var gridThemeHader: NSTextField!
    @IBOutlet weak var gridThemeContent: NSSegmentedControl!
    
    @IBOutlet weak var layoutSelectionHeader: NSTextField!
    @IBOutlet weak var layoutSelectionContent: NSCollectionView!
    
    private let appearanceInteractor: AppearanceInteractor = AppDependenciesResolver.shared.resolve(type: AppearanceInteractor.self)
    private let windowInteractor: WindowInteractor = AppDependenciesResolver.shared.resolve(type: WindowInteractor.self)
    private let layoutSchemesInteractor: LayoutSchemesInteractor = AppDependenciesResolver.shared.resolve(type: LayoutSchemesInteractor.self)
    private let gridLayoutInteractor: GridLayoutInteractor = AppDependenciesResolver.shared.resolve(type: GridLayoutInteractor.self)
    
    private lazy var uiDelegates: [SettingsDelegate]  = {
        [
            SettingsAppearanceDelegate(header: appearanceHeader, content: appearanceContent, appearanceInteractor: appearanceInteractor),
            SettingsDesktopLayoutDelegate(header: desktopLayoutHeader, content: desktopLayoutView, windowInteractor: windowInteractor, layoutSchemesInteractor: layoutSchemesInteractor, gridLayoutInteractor: gridLayoutInteractor),
            SettingsGridLayoutDelegate(header: gridThemeHader, content: gridThemeContent, gridLayoutInteractor: gridLayoutInteractor),
            SettingsLayoutSelectionDelegate(header: layoutSelectionHeader, content: layoutSelectionContent, layoutSchemasInteractor: layoutSchemesInteractor)
        ]
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        for uiDelegate in uiDelegates {
            uiDelegate.update()
        }
    }

}
