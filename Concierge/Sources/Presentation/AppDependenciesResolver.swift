import Foundation

class AppDependenciesResolver: DependenciesResolver {

    static let shared: DependenciesResolver = AppDependenciesResolver()
    
    private let diContainer: DependenciesContainer
    
    private init() {
        self.diContainer = SynchronizedDependenciesContainer.proxy(diContainer: GraphDependenciesContainer())
        register()
    }
    
    func resolve<Component>(type: Any) -> Component {
        return diContainer.resolve(type: type)
    }
    
    private func register() {
        registerUI()
        registerControllers()
        registerRepositories()
        registerInteractors()
    }
    
    private func registerUI() {
        diContainer.register(forType: StatusBarMenuController.self) { _ in
            return StatusBarMenuController()
        }
        
        diContainer.register(forType: RightSideMenuItemsFactory.self) { resolver in
            return RightSideMenuItemsFactory(layoutSchemesRepository: resolver.resolve(type: LayoutSchemesRepository.self),
                                             windowInteractor: resolver.resolve(type: WindowInteractor.self))
        }
    }
    
    private func registerControllers() {
        diContainer.register(forType: WindowController.self, andQualifier: .singleton) { _ in
            return WindowController()
        }
        
        diContainer.register(forType: HotKeyController.self, andQualifier: .singleton) { _ in
            return HotKeyController()
        }
        
        diContainer.register(forType: ScreensController.self, andQualifier: .singleton) { resolver in
            return ScreensController(windowController: resolver.resolve(type: WindowController.self))
        }
    }
    
    private func registerRepositories() {
        diContainer.register(forType: WindowRepository.self) { resolver in
            return WindowRepository(windowController: resolver.resolve(type: WindowController.self))
        }
        
        diContainer.register(forType: LayoutSchemesRepository.self) { _ in
            return LayoutSchemesRepository()
        }
    }
    
    private func registerInteractors() {
        diContainer.register(forType: HotKeysInteractor.self) { resolver in
            return HotKeysInteractor(layoutSchemesRepository: resolver.resolve(type: LayoutSchemesRepository.self),
                                  windowInteractor: resolver.resolve(type: WindowInteractor.self),
                                  hotKeysController: resolver.resolve(type: HotKeyController.self))
        }
        
        diContainer.register(forType: WindowInteractor.self) { resolver in
            return WindowInteractor(windowRepository: resolver.resolve(type: WindowRepository.self),
                                    screenController: resolver.resolve(type: ScreensController.self))
        }
    }
    
}
