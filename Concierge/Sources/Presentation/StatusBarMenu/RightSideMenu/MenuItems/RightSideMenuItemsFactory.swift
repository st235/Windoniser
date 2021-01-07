import Foundation

class RightSideMenuItemsFactory {
    
    private let layoutSchemesRepository: LayoutSchemesRepository
    
    private let windowRepository: WindowRepository
    private let screenController: ScreensController
    
    init(layoutSchemesRepository: LayoutSchemesRepository = AppDependenciesResolver.shared.resolve(type: LayoutSchemesRepository.self),
         windowRepository: WindowRepository = AppDependenciesResolver.shared.resolve(type: WindowRepository.self),
         screenController: ScreensController = AppDependenciesResolver.shared.resolve(type: ScreensController.self)) {
        self.layoutSchemesRepository = layoutSchemesRepository
        self.windowRepository = windowRepository
        self.screenController = screenController
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
            items.append(SchemeAreaMenuItem(area: area, windowRepository: windowRepository, screenController: screenController))
        }
        
        return items
    }
  
    private func createQuitItem() -> MenuItem {
        return QuitMenuItem()
    }
    
}
