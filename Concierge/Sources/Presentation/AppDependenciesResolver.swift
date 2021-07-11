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
        diContainer.register(forType: MainWindowController.self) { resolver in
            return MainWindowController(layoutSchemesInteractor: resolver.resolve(type: LayoutSchemesInteractor.self),
                                           accessibilityPermissionsManager: resolver.resolve(type: AccessibilityPermissionsManager.self),
                                           viewControllerFactory: resolver.resolve(type: ViewControllerFactory.self),
                                           appearanceController: resolver.resolve(type: SystemAppearanceController.self),
                                           windowInteractor: resolver.resolve(type: WindowInteractor.self))
        }
    }
    
    private func registerControllers() {
        diContainer.register(forType: TouchBarBuilder.self, andQualifier: .singleton) { resolver in
            return TouchBarBuilder(layoutSchemesInteractor: resolver.resolve(type: LayoutSchemesInteractor.self),
                                   windowInteractor: resolver.resolve(type: WindowInteractor.self))
        }
        
        diContainer.register(forType: ViewControllerFactory.self, andQualifier: .factory) { _ in
            return ViewControllerFactory()
        }
        
        diContainer.register(forType: WindowController.self, andQualifier: .singleton) { _ in
            return WindowController()
        }
        
        diContainer.register(forType: HotKeyController.self, andQualifier: .singleton) { _ in
            return HotKeyController()
        }
        
        diContainer.register(forType: ScreensController.self, andQualifier: .singleton) { resolver in
            return ScreensController(windowController: resolver.resolve(type: WindowController.self))
        }
        
        diContainer.register(forType: SystemAppearanceController.self, andQualifier: .singleton) { resolver in
            return SystemAppearanceController(appearanceInteractor: resolver.resolve(type: AppearanceInteractor.self))
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
            return HotKeysInteractor(layoutSchemesInteractor: resolver.resolve(type: LayoutSchemesInteractor.self),
                                  windowInteractor: resolver.resolve(type: WindowInteractor.self),
                                  hotKeysController: resolver.resolve(type: HotKeyController.self),
                                  settingsRepository: resolver.resolve(type: SettingsRepository.self))
        }
        
        diContainer.register(forType: WindowInteractor.self) { resolver in
            return WindowInteractor(windowRepository: resolver.resolve(type: WindowRepository.self),
                                    screenController: resolver.resolve(type: ScreensController.self))
        }
        
        diContainer.register(forType: LayoutSchemesInteractor.self, andQualifier: .singleton) { resolver in
            return LayoutSchemesInteractor(layoutSchemesRepository: resolver.resolve(type: LayoutSchemesRepository.self), settingsRepository: resolver.resolve(type: SettingsRepository.self))
        }
        
        diContainer.register(forType: AccessibilityPermissionsManager.self, andQualifier: .factory) { _ in
            return AccessibilityPermissionsManager()
        }
        
        diContainer.register(forType: SettingsRepository.self, andQualifier: .singleton) { _ in
            return SettingsRepository()
        }
        
        diContainer.register(forType: AppearanceInteractor.self, andQualifier: .singleton) { resolver in
            return AppearanceInteractor(settingsRepository: resolver.resolve(type: SettingsRepository.self))
        }
        
        diContainer.register(forType: GridLayoutInteractor.self, andQualifier: .singleton) { resolver in
            return GridLayoutInteractor(settingsRepository: resolver.resolve(type: SettingsRepository.self))
        }
        
        diContainer.register(forType: AutoLoginInteractor.self, andQualifier: .singleton) { resolver in
            return AutoLoginInteractor(settingsRepository: resolver.resolve(type: SettingsRepository.self))
        }
    }
    
}
