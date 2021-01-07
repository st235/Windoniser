import Foundation

class AppDependenciesResolver: DependenciesResolver {

    static let shared: DependenciesResolver = AppDependenciesResolver()
    
    private let diContainer: DependenciesContainer
    
    private init() {
        self.diContainer = GraphDependenciesContainer()
        register()
    }
    
    func resolve<Component>(type: Any) -> Component {
        return diContainer.resolve(type: type)
    }
    
    private func register() {
        registerUI()
        registerControllers()
        registerRepositories()
    }
    
    private func registerUI() {
        diContainer.register(type: StatusBarMenuController.self, andLazy: Provider<StatusBarMenuController>.create(resolveList: [], handler: { _ in
            return StatusBarMenuController()
        }))
    }
    
    private func registerControllers() {
        diContainer.register(type: WindowController.self, andValue: WindowController())
        diContainer.register(type: HotKeyController.self, andValue: HotKeyController())
        
        
        diContainer.register(type: ScreensController.self, andLazy: Provider<WindowController>.create(resolveList: [WindowController.self], handler: { resolver in
            return ScreensController(windowController: resolver.resolve(type: WindowController.self))
        }))
    }
    
    private func registerRepositories() {
        diContainer.register(type: WindowRepository.self, andLazy: Provider<WindowRepository>.create(resolveList: [WindowController.self], handler: { resolver in
            return WindowRepository(windowController: resolver.resolve(type: WindowController.self))
        }))
        
        diContainer.register(type: LayoutSchemesRepository.self, andLazy: Provider<LayoutSchemesRepository>.create(resolveList: [], handler: { _ in
            return LayoutSchemesRepository()
        }))
        
        diContainer.register(type: HotKeysManager.self, andLazy: Provider<HotKeysManager>.create(resolveList: [LayoutSchemesRepository.self, WindowRepository.self, ScreensController.self, HotKeyController.self], handler: { resolver in
            return HotKeysManager(layoutSchemesRepository: resolver.resolve(type: LayoutSchemesRepository.self),
                                  windowRepository: resolver.resolve(type: WindowRepository.self),
                                  screenController: resolver.resolve(type: ScreensController.self),
                                  hotKeysController: resolver.resolve(type: HotKeyController.self))
        }))
    }
    
}
