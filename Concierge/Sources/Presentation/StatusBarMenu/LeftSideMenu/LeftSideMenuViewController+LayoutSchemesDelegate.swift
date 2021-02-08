import Foundation

extension LeftSideMenuViewController: LayoutSchemesInteractor.Delegate {
    
    func onActiveSchemeChanged(schemes: LayoutScheme) {
        reloadActiveScheme()
    }
    
}
