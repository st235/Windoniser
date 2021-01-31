import Foundation

class RightSideMenuItemsFactory {
    
    private let layoutSchemesInteractor: LayoutSchemesInteractor
    
    private let windowInteractor: WindowInteractor
    
    init(layoutSchemesInteractor: LayoutSchemesInteractor,
         windowInteractor: WindowInteractor) {
        self.layoutSchemesInteractor = layoutSchemesInteractor
        self.windowInteractor = windowInteractor
    }
    
    func create() -> [MenuItem] {
        var items: [MenuItem] = []
        
        for item in createPrefferedScheme() {
            items.append(item)
        }
        
        items.append(Separator())
        items.append(SettingMenuItem())
        items.append(createQuitItem())
        
        return items
    }
    
    private func createPrefferedScheme() -> [MenuItem] {
        var items: [MenuItem] = []
        let prefferedScheme = layoutSchemesInteractor.activeScheme
        
        for area in prefferedScheme.areas {
            items.append(SchemeAreaMenuItem(area: area, windowInteractor: windowInteractor))
        }
        
        return items
    }
  
    private func createQuitItem() -> MenuItem {
        return QuitMenuItem()
    }
    
}
