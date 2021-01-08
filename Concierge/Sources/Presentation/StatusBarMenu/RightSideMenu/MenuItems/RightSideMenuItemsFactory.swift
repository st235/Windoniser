import Foundation

class RightSideMenuItemsFactory {
    
    private let layoutSchemesRepository: LayoutSchemesRepository
    
    private let windowInteractor: WindowInteractor
    
    init(layoutSchemesRepository: LayoutSchemesRepository,
         windowInteractor: WindowInteractor) {
        self.layoutSchemesRepository = layoutSchemesRepository
        self.windowInteractor = windowInteractor
    }
    
    func create() -> [MenuItem] {
        var items: [MenuItem] = []
        
        for item in createPrefferedScheme() {
            items.append(item)
        }
        
        items.append(Separator())
        items.append(createQuitItem())
        
        return items
    }
    
    private func createPrefferedScheme() -> [MenuItem] {
        var items: [MenuItem] = []
        let prefferedScheme = layoutSchemesRepository.providePreferredScheme()
        
        for area in prefferedScheme.areas {
            items.append(SchemeAreaMenuItem(area: area, windowInteractor: windowInteractor))
        }
        
        return items
    }
  
    private func createQuitItem() -> MenuItem {
        return QuitMenuItem()
    }
    
}
