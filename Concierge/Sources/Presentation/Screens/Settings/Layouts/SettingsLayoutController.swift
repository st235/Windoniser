import Foundation

class SettingsLayoutController: NSViewController {
    
    @IBOutlet weak var desktopLayoutHeader: NSTextField!
    @IBOutlet weak var dekstopLayoutView: DesktopLayoutView!
    
    @IBOutlet weak var gridsHeader: NSTextField!
    @IBOutlet weak var gridsCollectionView: NSCollectionView!
    
    private let appearanceInteractor: AppearanceInteractor = AppDependenciesResolver.shared.resolve(type: AppearanceInteractor.self)
    private let windowInteractor: WindowInteractor = AppDependenciesResolver.shared.resolve(type: WindowInteractor.self)
    private let layoutSchemesInteractor: LayoutSchemesInteractor = AppDependenciesResolver.shared.resolve(type: LayoutSchemesInteractor.self)
    private let gridLayoutInteractor: GridLayoutInteractor = AppDependenciesResolver.shared.resolve(type: GridLayoutInteractor.self)
    
    private lazy var uiDelegates: [UiDelegate]  = {
        [
            DesktopViewUiDelegate(header: desktopLayoutHeader, content: dekstopLayoutView, windowInteractor: windowInteractor, layoutSchemesInteractor: layoutSchemesInteractor, gridLayoutInteractor: gridLayoutInteractor),
            SettingsLayoutSelectionDelegate(header: gridsHeader, content: gridsCollectionView, layoutSchemasInteractor: layoutSchemesInteractor)
        ]
    }()
    
    override func viewDidLoad() {
        for uiDelegate in uiDelegates {
            uiDelegate.update()
        }
    }
    
}
